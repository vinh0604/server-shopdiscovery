object false
child(@object) do
  extends 'api/notification'
end
node(:total) { @object.total_count }
node(:offset) { @object.offset_value }