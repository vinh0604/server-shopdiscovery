object false
child(@object) do
  extends 'api/review'
end
node(:total) { @object.total_count }
node(:offset) { @object.offset_value }
