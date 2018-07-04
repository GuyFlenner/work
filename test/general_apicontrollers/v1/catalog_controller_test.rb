require 'test_helper'

module GeneralApi
  module V1
    class CatalogControllerTest < ActionController::TestCase
      include LoginHelper

      setup do
        @user = User.last  #this is filled with seeds mechanism (http://www.xyzpub.com/en/ruby-on-rails/3.2/seed_rb.html)
        setup_catalog
      end

      # should include also test for un authorized request (not included because i returned hard coded true on user credential check)
      #
      test 'get catalog items for Nestle producer' do
        login(@user)  # method that save user credential cookies user authorized

        xhr :get, :index, {producer: 'Nestle'}
        assert_response 200
        res = JSON.parse(response.body)
        assert_equal Catalog.by_producer('Nestle').map(&:product_name), res['list'].map{|x|x['product_name']}
      end

      private

      # should be place in seed folder (so we can just write Catalog.where... on every test file)
      #
      def setup_catalog
        [
          {product_name: 'bamba', photo_url: 'dummy_url1', barcode: 'xxx1', sku: 111, price: 2.23, producer: 'Nestle'},
          {product_name: 'apple', photo_url: 'dummy_url2', barcode: 'xxx2', sku: 555, price: 4.66, producer: 'WFM'},
          {product_name: 'tapu chepse', photo_url: 'dummy_url3', barcode: 'xxx3', sku: 1111444, price: 7.33, producer: 'Nestle'}
        ].each do |data|
          Catalog.create(data)
        end
      end
    end
  end
end
