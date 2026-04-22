class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name
      t.integer :allocated_time
      t.integer :current_time
      t.date :start_date
      t.date :due_date

      t.timestamps
    end
  end
end
