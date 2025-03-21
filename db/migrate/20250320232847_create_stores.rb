class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :store_hash, null: false
      t.string :access_token
      t.string :scope
      t.timestamps
    end
  end
end
