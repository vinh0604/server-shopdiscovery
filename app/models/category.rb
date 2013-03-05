class Category < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Category', :foreign_key => "parent_id"
  has_many :children, :class_name => "Category", :foreign_key => "parent_id"
  has_many :products

  before_save :update_sequence

  def self.categories_tree(category = nil)
    _tree = []
    _categories = if category
      category.children
    else
      self.where{(parent_id == nil) | (parent_id == '')}
    end
    _categories.each do |cat|
      cat_json = cat.as_json(:only => [:id, :name])
      cat_json[:children] = self.categories_tree(cat)
      cat_json[:hasChild] = true if cat_json[:children].length > 0
      _tree << cat_json
    end
    _tree
  end

  def has_children?
    children.count > 0
  end

  def ancestors
    if @ancestors.nil?
      @ancestors = []
      ids = self.sequence.to_s.split(',')
      ids.each do |_id|
        c = Category.find_by_id(_id)
        @ancestors << c.name unless c.nil?
      end
    end
    @ancestors
  end

  def all_children
    if !has_children?
      [id]
    else
      Category.where("? = ANY(regexp_split_to_array(sequence,','))", self.id.to_s).
               all.map { |c| c.id }
    end
  end

  private
  def update_sequence
    if self.parent
      sequences = self.parent.sequence.to_s.split(',')
      sequences << self.parent.id
      self.sequence = sequences.join(',')
    end
  end
end
