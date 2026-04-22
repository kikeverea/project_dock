class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name
      t.datetime :date
      t.references :proposed_by, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
