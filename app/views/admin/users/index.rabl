object false

node(:total) {|m| @users.total_count }
node(:total_pages) {|m| @users.total_pages }

child(@users) do
  extends "admin/users/show"
end