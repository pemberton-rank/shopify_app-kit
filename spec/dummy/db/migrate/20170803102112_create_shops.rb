class CreateShops < ActiveRecord::Migration[5.1]
  def change
    create_table :shops do |t|
      t.string :shopify_domain
      t.string :shopify_token
      t.timestamps
    end

    add_column :users, :shop_id, :integer
  end
end
