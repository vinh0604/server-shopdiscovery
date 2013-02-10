class MessageReceiver < ActiveRecord::Base
  STATUSES = {
    :new => 0,
    :read => 1
  }.freeze

  belongs_to :message
  belongs_to :user

  scope :unread, where(:status => STATUSES[:new]) 

  def unread?
    status == STATUSES[:new]
  end
end
