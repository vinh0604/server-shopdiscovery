collection @object, :object_root => false
attributes :id, :name, :barcode, :specifics
child :category do
  attributes :id, :name, :ancestors
end