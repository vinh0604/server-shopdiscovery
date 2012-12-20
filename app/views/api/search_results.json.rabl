object false
child(@object) do
  extends 'api/search_result'
end
node(:total) { @object.total_count }
node(:offset) { @object.offset_value }