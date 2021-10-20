# frozen_string_literal: true

Rails.application.routes.draw do
  get :health, to: ->( _env ) { [ 200, {}, [ "ok" ] ] }

  get "/login", as: :login_form, to: "auth#login_form"
  post "/login", as: :login, to: "auth#login"
  post "/token/:id", as: :token, to: "auth#token"

  scope :x do
    resources :roles, param: :name, except: [ :destroy ]
  end
end
