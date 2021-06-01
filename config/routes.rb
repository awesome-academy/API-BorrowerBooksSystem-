Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :api do
      namespace :v1 do
        resources :requests, only: %i(index create)
      end
    end
  end
  post :login, to: "authentication#login"
end
