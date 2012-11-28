require 'spec_helper'

describe User do
  it "has a contact" do
    user = User.new
    user.should respond_to :contact
  end

  it "has a avatar" do
    user = User.new
    user.should respond_to :avatar
    user.avatar.should respond_to :url
  end

  context "creation" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "returns false if username or email or password is nil" do
      user = User.new(:email => 'abc@abc.com')
      user.save.should be_false

      user.password = '123456'
      user.password_confirmation = '123456'
      user.save.should be_false

      user.username = 'abc'
      user.save.should be_true
    end

    it "returns false if email or username is existing" do
      user = User.new
      user.password = '123456'
      user.password_confirmation = '123456'

      user.username = 'abc'
      user.email = 'vinh@gmail.com'
      user.save.should be_false

      user.username = 'vinh'
      user.email = 'abc@abc.com'
      user.save.should be_false

      user.username = 'abc'
      user.email = 'abc@abc.com'
      user.save.should be_true
    end

    it "generates authentication token" do
      user = User.create(:username => 'abc', :email => 'abc@abc.com',
                        :password => '123456', :password_confirmation => '123456')
      user.authentication_token.should_not be_blank
    end
  end

  context "login" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "returns nil if password is not correct" do
      username = 'vinh'
      password = '12345'
      user = User.find_for_database_authentication(:login => username)
      user.valid_password?(password).should be_false
    end

    it "returns nil if email or username is not existed" do
      username = 'vinh1'
      User.find_for_database_authentication(:login => username).should be_nil

      email = 'vinh@abc.com'
      User.find_for_database_authentication(:login => email).should be_nil
    end

    it "success if email or username match with password" do
      username = 'vinh'
      email = 'vinh@gmail.com'
      password = '123456'

      user = User.find_for_database_authentication(:login => username)
      user.valid_password?(password).should be_true

      user = User.find_for_database_authentication(:login => email)
      user.valid_password?(password).should be_true
    end
  end
end
