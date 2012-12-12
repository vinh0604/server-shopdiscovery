object false
child(@object) do
  extends 'api/shop_product_list'
end
node(:total) { @object.total_count }
node(:offset) { @object.offset_value }
