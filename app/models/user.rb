class User < ActiveRecord::Base
  belongs_to :contact
  has_many :reviews, :foreign_key => 'reviewer_id'
  has_many :favorite_shops, :dependent => :delete_all
  has_many :wish_lists, :dependent => :delete_all
  has_many :managers, :dependent => :delete_all
  has_many :notifications, :dependent => :delete_all
  has_many :message_receivers, :dependent => :delete_all
  has_many :orders, :dependent => :delete_all
  has_many :messages, :foreign_key => 'sender_id'

  devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  mount_uploader :avatar, AvatarUploader

  validates_presence_of :username
  validates_uniqueness_of :username

  attr_accessor :login, :current_password
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["username = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
