require 'spec_helper'

describe "Users" do
  describe "POST /api/v1/users/" do
    before(:each) do
      @params = FactoryGirl.attributes_for(:user) do |u|
        u[:first_name] = 'Vinh'
        u[:last_name] = 'Bach'
        u[:gender] = 1
      end
    end

    it "returns status 400 if required params not existed" do
      post 'api/v1/users'
      response.status.should == 400
    end

    context "returns status 400 and error messages" do
      before(:each) do
        @new_params = @params.clone
      end
      it "if email is not in correct format" do
        @new_params[:email] = 'vinh'
        post 'api/v1/users', @new_params
        response.status.should == 400
      end

      it "if password confirmation is not matched" do
        @new_params[:password_confirmation] = '123'
        post 'api/v1/users', @new_params
        response.status.should == 400
      end

      it "if email or username is existed" do
        user = FactoryGirl.create(:user)
        post 'api/v1/users', @new_params
        response.status.should == 400
      end
    end

    it "returns user if success" do
      post 'api/v1/users', @params
      response.status.should == 201
      user = User.find_by_email(@params[:email])
      response.body.should == user.to_json
    end
  end

  describe "PUT api/v1/profile/" do
    before(:each) do
      @user = FactoryGirl.build(:user) do |u|
        u.contact = FactoryGirl.create(:contact)
      end
      @user.save
    end

    it "updates avatar if params[:avatar] provided" do
      @file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/user.png'), 'image/png')
      put 'api/v1/profile/', {:auth_token => @user.authentication_token, :avatar => @file}
      response.status.should == 200
      response_data = JSON.parse response.body
      response_data['avatar']['url'].should_not be_blank
    end

    it "updates user's contact and returns status 200 with new user and contact data" do
      contact_attributes = {:first_name => 'Vinh1'}

      put 'api/v1/profile/', {:auth_token => @user.authentication_token, :contact => contact_attributes.to_json}
      response.status.should == 200
      response_data = JSON.parse response.body
      response_data['contact']['first_name'].should == contact_attributes[:first_name]
    end
  end

  describe "GET /api/v1/profile" do
    before(:each) do
      @user = FactoryGirl.build(:user) do |u|
        u.contact = FactoryGirl.create(:contact)
      end
      @user.save
    end

    it "returns status 401 authentication failed" do
      get 'api/v1/profile/'
      response.status.should == 401
    end

    it "returns status 200 with user and contact data if authentication success" do
      get 'api/v1/profile/', {:auth_token => @user.authentication_token}
      response.status.should == 200
      response_data = JSON.parse response.body
      response_data['contact'].should_not be_blank
    end
  end

  describe "PUT /api/v1/passwords" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    context "returns status 400 and error messages" do
      it "if current password is not correct" do
        params = {
          :auth_token => @user.authentication_token,
          :current_password => '12345',
          :password => 'abcdef',
          :password_confirmation => 'abcdef'
        }
        put 'api/v1/passwords', params
        response.status.should == 400
      end

      it "if new password confirmation is not matched" do
        params = {
          :auth_token => @user.authentication_token,
          :current_password => '123456',
          :password => 'abcdef',
          :password_confirmation => '123456'
        }
        put 'api/v1/passwords', params
        response.status.should == 400
      end
    end 

    it "returns status 200 if success" do
      params = {
        :auth_token => @user.authentication_token,
        :current_password => '123456',
        :password => 'abcdef',
        :password_confirmation => 'abcdef'
      }
      put 'api/v1/passwords', params
      response.status.should == 200
      response.body.should == {success: true}.to_json
    end
  end
end
