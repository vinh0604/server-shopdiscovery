require 'spec_helper'

describe Photo do
  before(:each) do
    @photo = Photo.new
  end

  it "has an imageable object" do
    @photo.should respond_to :imageable
  end

  it "has an image" do
    @photo.should respond_to :image
    @photo.image.should respond_to :url
  end
end
