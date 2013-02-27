class CreateSearchCompletions < ActiveRecord::Migration
  def change
    create_table :search_completions do |t|
      t.string :search_term
      t.integer :search_count, :default => 0

      t.timestamps
    end
  end
end
