object false
child(@object) do
  extends 'api/promotion'
end
node(:total) { @object.total_count }
node(:offset) { @object.offset_value }