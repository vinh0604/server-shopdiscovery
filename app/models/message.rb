class Message < ActiveRecord::Base
  STATUSES = {
    :draft => 0,
    :sent => 1,
    :deleted => 2
  }.freeze
  belongs_to :sender, :class_name => 'User'
  has_many :message_receivers, :dependent => :delete_all

  scope :active, where{status != STATUSES[:deleted]}

  def headline
    @headline ||= truncate(content, :separator => ' ')
  end
end
