class CreateCatalogTbl < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.string  :product_name
      t.string  :photo_url
      t.string  :barcode
      t.integer :sku
      t.float   :price
      t.string  :producer
      t.timestamps
    end

    add_index :catalogs, [:sku, :producer], unique: true, name: 'by_sku_and_producer'
  end
end
