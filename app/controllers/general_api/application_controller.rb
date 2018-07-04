module GeneralApi
  class ApplicationController < ::ApplicationController
    layout false

    protected

    def require_authentication
      logged_out_error_message unless authenticate_user # return error json to client if not authorized request
      @user # the verified logged in user who made the request
    end

    def missing_params_error_message(text = 'missing parameters')
      send_error_message(text)
    end

    def logged_out_error_message(text = 'logged out user')
      send_error_message(text)
    end

    def send_error_message(text = 'error', status: :bad_request)
      render status: status, json: {error_message: text}
    end

    def authenticate_user
      true # implement here authentication of user (based cookie for example)
    end

    def set_cache_ttl(cdn_ttl, browser_ttl=0)
      response.headers['Surrogate-Control'] = "max-age=#{cdn_ttl}, stale-while-revalidate=30, stale-if-error=86400"
      response.headers['Cache-Control'] = "max-age=#{browser_ttl}"
    end
  end
end
