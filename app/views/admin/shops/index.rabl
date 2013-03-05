object false

node(:total) {|m| @shops.total_count }
node(:total_pages) {|m| @shops.total_pages }

child(@shops) do
  extends "admin/shops/index_shop"
end