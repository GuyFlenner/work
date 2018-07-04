module GeneralApi
  module V1
    class CatalogController < GeneralApi::ApplicationController
      include CatalogHelper

      before_filter :require_authentication, only: [:index]

      ITEMS_PER_PAGE = 5

      # usage example: /api/v1/catalog/general?per_page=1&page=2
      #
      def index
        return missing_params_error_message if (producer = params[:producer]).blank?

        page = params[:page].to_i
        per_page = (params[:per_page] || ITEMS_PER_PAGE).to_i
        list = catalog_data({per_page: per_page, page: page, producer: producer})
        set_cache_ttl(15.minutes)

        render json: {list: list}
      end
    end
  end
end
