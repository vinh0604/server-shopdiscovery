require 'spec_helper'

describe Manager do
  before(:each) do
    @manager = FactoryGirl.build(:manager)
  end
  it "belongs to a shop" do
    @manager.should respond_to(:shop)
  end
  it "belongs to a user" do
    @manager.should respond_to(:user)
  end
end
