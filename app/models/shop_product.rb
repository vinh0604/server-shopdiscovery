class ShopProduct < ActiveRecord::Base
  belongs_to :shop
  belongs_to :product
  has_many :photos, :as => :imageable, :dependent => :delete_all
  has_many :reviews, :as => :reviewable, :dependent => :delete_all
  has_many :wish_lists, :dependent => :delete_all
  has_many :promotions, :dependent => :delete_all
  has_one :thumb, :class_name => 'Photo', :as => :imageable,
          :conditions => {:ordinal => 1}
  has_one :active_promotion, :class_name => 'Promotion',
          :conditions => ["promotions.expires > ?", DateTime.now]

  scope :nearby, lambda { |loc,distance|
    joins(:shop).where("ST_DWithin(ST_GeographyFromText(?), shops.location, ?) = 't'", loc, distance*1000)
  }

  scope :keyword, lambda { |keyword|
    joins(:product).where("products.textsearchable@@plainto_tsquery('product',?) = 't'", keyword)
  }

  scope :barcode, lambda { |barcode|
    joins(:product).where('products.barcode' => barcode)
  }

  scope :category, lambda { |categories|
    joins(:product).where('products.category_id' => categories)
  }

  scope :condition, lambda { |condition|
    where(:status => condition)
  }

  scope :minimum_price, lambda { |min_price|
    where{price >= min_price}
  }

  scope :maximum_price, lambda { |max_price|
    where{price <= max_price}
  }

  scope :minimum_score, lambda { |min_score|
    where{avg_score >= min_score}
  }

  scope :with_sort, lambda { |sort_type, value|
    if sort_type == SORT_TYPE[:price_low]
      order('shop_products.price')
    elsif sort_type == SORT_TYPE[:price_high]
      order('shop_products.price DESC')    
    elsif sort_type == SORT_TYPE[:distance]
      order("ST_Distance(ST_GeographyFromText('#{value}'), shops.location)")
    elsif sort_type == SORT_TYPE[:review_score]
      order('shop_products.avg_score')
    else
      order("ts_rank(products.textsearchable, plainto_tsquery('product','#{value}')) DESC")
    end
  }

  SORT_TYPE = {
    :relevance => 1,
    :price_low => 2,
    :price_high => 3,
    :distance => 4,
    :review_score => 5
  }

  def self.search_products(params)
    keyword = params[:keyword] ? params[:keyword].strip.gsub('-',' ') : ''
    # get filtered categories for product
    if params[:category].blank?
      category_ids = []
    else
      category = Category.find_by_id(params[:category])
      category_ids = category ? category.all_children : []
    end

    query = self.includes(:shop, :product)
    if keyword.start_with?('EAN:')
      query = query.barcode(keyword.sub('EAN:','').gsub(' ',''))
    else
      query = query.keyword(keyword)
    end
    # filter search result
    query = query.nearby(params[:location], params[:distance]) if params[:location] and params[:distance]
    query = query.condition(params[:condition]) if params[:condition]
    query = query.category(category_ids) unless category_ids.empty?
    query = query.minimum_price(params[:min_price]) if params[:min_price]
    query = query.maximum_price(params[:max_price]) if params[:max_price]
    query = query.minimum_score(params[:min_score]) if params[:min_score]
    # sort search result
    if params[:sort].blank? || params[:sort] == SORT_TYPE[:relevance]
      query = query.with_sort(params[:sort], keyword)
    elsif params[:sort] == SORT_TYPE[:distance]
      query = query.with_sort(params[:sort], params[:location])
    else
      query = query.with_sort(params[:sort], '')
    end
    # paginate search result
    if params[:page] and params[:per_page]
      query = query.page(params[:page]).per(params[:per_page])
    elsif params[:page]
      query = query.page(params[:page])
    else
      query = query.page(1)
    end

    if params[:location]
      query.each do |q| 
        if q.shop
          q.shop.distance = Shop.select("ST_Distance(ST_GeographyFromText('#{params[:location]}'), shops.location) as shop_distance").
                                 find_by_id(q.shop_id).shop_distance.to_f / 1000;
        end
      end
    end

    query
  end
end
