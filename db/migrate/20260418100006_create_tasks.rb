class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :status
      t.string :task_type
      t.datetime :latest_status_at
      t.datetime :expires_at
      t.references :activity, null: true, foreign_key: true

      t.timestamps
    end
  end
end
