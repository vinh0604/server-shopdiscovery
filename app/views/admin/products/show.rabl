object @product

attributes :id, :name, :barcode, :specifics
child :category do
  attributes :id, :name
end
child :tags do
  attributes :id, :value
end