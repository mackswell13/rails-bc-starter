class CreateStoreRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :store_relationships do |t|
      t.belongs_to :user
      t.belongs_to :store
      t.boolean :is_owner
      t.integer :bc_id
      t.timestamps
    end
  end
end
