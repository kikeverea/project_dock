class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :status
      t.integer :order
      t.datetime :latest_status_at
      t.references :activity, null: true, foreign_key: true
      t.datetime :tasks, :discarded_at

      t.timestamps
    end

    add_index :tasks, :discarded_at
  end
end
