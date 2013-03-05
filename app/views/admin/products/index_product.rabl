object @product

attributes :id, :name, :barcode
child :category do
  attributes :id, :name
end