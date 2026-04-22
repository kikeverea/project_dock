class CreateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :logs do |t|
      t.references :loggable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.string :action

      t.timestamps
    end
  end
end
