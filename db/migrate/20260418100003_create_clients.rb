class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.datetime :discarded_at

      t.timestamps
    end
  end
end
