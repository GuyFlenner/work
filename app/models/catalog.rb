class Catalog < ActiveRecord::Base
  scope :by_producer, -> (producer) {where(producer: producer).where('').order('product_name ASC')}
end
