class Message < ActiveRecord::Base
  STATUSES = {
    :draft => 0,
    :sent => 1
  }.freeze
  belongs_to :sender, :class_name => 'User'
  has_many :message_receivers, :dependent => :delete_all
end
