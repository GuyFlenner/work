class Background::CatalogBackfill
  extend Resque::Plugins::JobStats
  extend Resque::Plugins::LockTimeout

  @lock_timeout = 1.hour
  @loner = true
  @queue = :background

  class << self
    def perform
      update_catalog_from_csv
    rescue Exception => e
      Rollbar.error('Background::CatalogBackfill error', e)
    end

    private

    # This method can be enhance if we'll decide to clean & recreate the entire table every 15 minutes
    # Another enhance will be to send deltas in the catalog.csv file so it will only update the relevant items and not the entire catalog every 15 minutes
    #
    def update_catalog_from_csv
      start_time = Time.now
      CSV.foreach('config/csv/catalog.csv', headers: true, header_converters: :symbol).with_index do |row, i|
        next unless row[:sku]
        producer = row[:producer] || 'General'
        catalog_item = Catalog.where(sku: row[:sku], producer: producer).first_or_initialize
        catalog_item.update_attributes!(product_name: row[:product_name], photo_url: row[:photo_url], barcode: row[:barcode], price: row[:price_cents].to_i/100)

        puts "finished processing #{i} records" if i%500 == 0
      end
      puts "Done!!! Took: #{((Time.now-start_time)/60).round(1)} minutes"
    end
  end
end
