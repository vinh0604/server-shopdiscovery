# encoding: UTF-8
class Product < ActiveRecord::Base
  belongs_to :category
  has_many :shop_products
  after_save :update_textsearchable

  serialize :specifics, ActiveRecord::Coders::Hstore

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
    Product.update_all "textsearchable = to_tsvector(coalesce(replace('#{self.name}','-',' '),'') || ' ' || coalesce('#{category_name}',''))", "id = #{self.id}"
  end
end
