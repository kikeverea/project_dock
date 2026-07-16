class CreateWorkUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :work_units do |t|
      t.string :title
      t.text :content
      t.string :type
      t.boolean :completable, default: false
      t.datetime :acknowledged_at
      t.datetime :completed_at
      t.datetime :discarded_at
      t.references :project, null: false, foreign_key: true
      t.references :parent_unit, null: true, foreign_key: { to_table: :work_units }
      t.references :created_by, null: true, foreign_key: { to_table: :users }
      t.references :completed_by, null: true, foreign_key: { to_table: :users }
      t.references :acknowledged_by, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :work_units, :discarded_at
  end
end
