class CreateInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :task_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.references :parent_comment, null: true, foreign_key: { to_table: :task_comments }
      t.text :content
      t.string :status

      t.timestamps
    end
  end
end
