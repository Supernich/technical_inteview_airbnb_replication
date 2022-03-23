# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'houses#index'

  resources :houses
  resources :house_bookings, only: %i[create destroy]
end
