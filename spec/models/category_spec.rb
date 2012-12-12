require 'spec_helper'

describe Category do
  before(:each) do
    @category = Category.new
  end

  it "has many products" do
    @category.should respond_to :products
  end

  it "may have a parent category" do
    @category.should respond_to(:parent)
    parent = FactoryGirl.create(:category)
    expect { @category.parent = parent }.to_not raise_error
  end

  it "may have many children" do
    @category.should respond_to(:children)
    @category.children.should be_instance_of Array
  end

  it "responds to has_children? method" do
    @category.should respond_to(:has_children?)
    @category.has_children?.should be(false)
  end

  context "callback" do
    before(:each) do
      @sub_category = FactoryGirl.create(:sub_category)
    end
    it "updates sequence before save" do
      @sub_category.sequence.should_not be_blank
      @sub_category.sequence.should == @sub_category.parent.id.to_s
    end
  end
end
