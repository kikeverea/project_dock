class CreateInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :interactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.references :parent_interaction, null: true, foreign_key: { to_table: :interactions }
      t.text :content
      t.string :status

      t.timestamps
    end
  end
end
