class Tag < ActiveRecord::Base
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :products
  has_and_belongs_to_many :users

  def self.create_tags(tag_values)
    _tags = []
    tag_values.each do |tag_value|
      tag_value = tag_value.mb_chars.downcase
      _tag = self.find_by_value(tag_value) || self.create(:value => tag_value)
      _tags << _tag
    end
    _tags
  end
end
