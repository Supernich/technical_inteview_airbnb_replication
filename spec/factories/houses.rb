# frozen_string_literal: true

FactoryBot.define do
  factory :house do
    name { FFaker.name }
    country { FFaker::Address.country }
    city { FFaker::Address.city }
    price { 100 }
  end
end
