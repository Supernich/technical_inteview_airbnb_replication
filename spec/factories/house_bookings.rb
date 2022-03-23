# frozen_string_literal: true

FactoryBot.define do
  factory :house_booking do
    house
    check_in { Date.current }
    check_out { Date.current + 1.days }
  end
end
