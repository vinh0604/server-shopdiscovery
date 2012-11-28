require 'spec_helper'

describe "Sessions" do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe "POST /api/v1/sessions/" do
    it "returns user if success" do
      post '/api/v1/sessions/', {:email => @user.username, :password => '123456'}
      response.status.should == 201
      response.body.should == @user.to_json
    end
  end

  describe "DELETE /api/v1/sessions/" do
    it "generates new authentication token" do
      last_token = @user.authentication_token
      delete '/api/v1/sessions/', {:auth_token => last_token}
      response.status.should == 200
      User.find(@user.id).authentication_token.should_not == last_token
    end
  end
end
