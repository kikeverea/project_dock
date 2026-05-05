class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name
      t.datetime :date
      t.integer :order
      t.text :generating_interaction
      t.references :proposed_by, null: true, foreign_key: { to_table: :users }
      t.datetime :activities, :discarded_at

      t.timestamps
    end

    add_index :activities, :discarded_at
  end
end
