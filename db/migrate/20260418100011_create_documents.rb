class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.references :documentable, polymorphic: true, null: false
      t.references :uploaded_by, null: false, foreign_key: { to_table: :users }
      t.string :file
      t.string :name

      t.timestamps
    end
  end
end
