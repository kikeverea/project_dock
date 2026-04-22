class CreateEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :emails do |t|
      t.references :emailable, polymorphic: true, null: false
      t.string :email

      t.timestamps
    end
  end
end
