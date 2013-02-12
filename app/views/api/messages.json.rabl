object false
child(@object) do
  extends 'api/message'
end
node(:total) { @object.total_count }
node(:offset) { @object.offset_value }