class CreatePhoneNumbers < ActiveRecord::Migration[7.1]
  def change
    create_table :phone_numbers do |t|
      t.references :phoneable, polymorphic: true, null: false
      t.string :number

      t.timestamps
    end
  end
end
