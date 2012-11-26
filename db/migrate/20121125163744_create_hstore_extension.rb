class CreateHstoreExtension < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS hstore;
    SQL
  end

  def down
  end
end
