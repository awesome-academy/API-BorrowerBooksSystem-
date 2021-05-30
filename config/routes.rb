Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :api do
      namespace :v1 do
        resources :requests, only: %i(index create) do
          match :search, via: [:get, :post], on: :collection
        end
      end
    end
  end
end
