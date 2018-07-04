Sapi::Application.routes.prepend do
  namespace :api, module: 'general_api' do

    namespace :v1 do
      scope 'catalog', controller: :catalog do
        get '/:producer', action: :index, :producer => /[^\/]+/
      end
    end
  end
end
