class Shop < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :shop_products
  has_many :favorite_shops, :dependent => :delete_all
  has_and_belongs_to_many :tags
  has_many :photos, :as => :imageable
  has_many :reviews, :as => :reviewable
  has_and_belongs_to_many :tags
  has_one :thumb, :class_name => 'Photo', :as => :imageable,
          :conditions => {:ordinal => 1}

  serialize :phones, Array
  # By default, use the GEOS implementation for spatial columns.
  # self.rgeo_factory_generator = RGeo::Geos.factory_generator
  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))
  attr_accessor :distance
  
  def full_address
    if @full_address.nil?
      @full_address = street_address
      @full_address += ', ' + district unless district.blank?
      @full_address += ', ' + city unless district.blank?
    end
    @full_address
  end
end
