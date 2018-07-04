module CatalogHelper
  include ActionView::Helpers::NumberHelper

  def catalog_data(param_hash)
    list = Catalog.by_producer(param_hash[:producer]).limit(param_hash[:per_page]).offset(param_hash[:per_page]*param_hash[:page])
    res = []
    list.each do |item|
      res << {
        product_name: item[:product_name],
        photo_url: item[:photo_url],
        barcode: item[:barcode],
        sku: item[:sku],
        price: number_with_precision(item[:price], precision: 2),
        producer: item[:producer]
      }
    end
    res
  end
end
