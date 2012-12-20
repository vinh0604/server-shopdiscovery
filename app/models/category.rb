class Category < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Category', :foreign_key => "parent_id"
  has_many :children, :class_name => "Category", :foreign_key => "parent_id"
  has_many :products

  before_save :update_sequence

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
    if has_children?
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
