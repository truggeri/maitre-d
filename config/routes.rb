# frozen_string_literal: true

Rails.application.routes.draw do
  get :health, to: ->( _env ) { [ 200, {}, [ "ok" ] ] }
end
