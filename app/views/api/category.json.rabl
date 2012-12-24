object :object_root => nil
node :category do |c|
  {:id => c.id, :name => c.name}
end
child :parent => :parent do
  attributes :id, :name
end
node :children  do |c|
  c.children.map do |child|
    {:id => child.id, :name => child.name}
  end
end
