# encoding: UTF-8
class Product < ActiveRecord::Base
  belongs_to :category
  has_many :shop_products
  has_and_belongs_to_many :tags
  after_save :update_textsearchable

  serialize :specifics, ActiveRecord::Coders::Hstore

  validates :name, :uniqueness => { :case_sensitive => false }
  validates :barcode , :uniqueness => true, :allow_blank => true, :allow_nil => true
  validates :name, :presence => true

  def min_price
    shop_products.minimum('price')
  end

  def shop_count
    shop_products.count
  end

  def thumb
    _shop_product = shop_products.first
    if _shop_product
      _shop_product.thumb
    else
      nil
    end
  end

  private
  def update_textsearchable
    _category = self.category
    if _category and _category.name == 'Khác'
      _category = _category.parent
    end
    category_name = _category ? _category.name : ''
    tag_value = self.tags.select("array_to_string(array_agg(tags.value), ' ') as tag_value").first.tag_value
    Product.update_all "textsearchable = to_tsvector('product',coalesce(replace('#{self.name}','-',' '),'') || ' ' || coalesce('#{category_name}','') || ' ' || coalesce('#{tag_value}',''))", "id = #{self.id}"
  end
end
