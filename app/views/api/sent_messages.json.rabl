object false
child(@object) do
  extends 'api/sent_message'
end
node(:total) { @object.total_count }
node(:offset) { @object.offset_value }