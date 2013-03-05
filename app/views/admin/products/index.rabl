object false

node(:total) {|m| @products.total_count }
node(:total_pages) {|m| @products.total_pages }

child(@products) do
  extends "admin/products/index_product"
end