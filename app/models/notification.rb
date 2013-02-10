class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, :polymorphic => true

  TYPES = {
    :promotion => 1,
    :new_product => 2,
    :price_change => 3
  }.freeze

  STATUSES = {
    :new => 0,
    :read => 1
  }.freeze

  scope :unread, where(:status => STATUSES[:new])

  def unread?
    status == STATUSES[:new]
  end

  def full_content
    @full_content ||= []
    regex = /\[\[([^\]]*)\]\]/
    matches = content.scan regex
    matches.each do |m|
      array = m.first.split(':')
      if array.length < 2
        @full_content << {value: array.first}
      elsif ['Product', 'Shop'].include? array[0]
        clazz = array[0].constantize
        _object = clazz.find_by_id(array[1])
        @full_content << {type: array[0], id: _object.id, value: _object.name}
      else 
        @full_content << {type: array[0], value: array[1]}
      end
    end
    @full_content
  end
end
