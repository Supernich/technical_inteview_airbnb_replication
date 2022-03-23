# frozen_string_literal: true

class House < ApplicationRecord
  has_many :house_bookings, dependent: :destroy

  validates(:name, :country, :city, presence: true)
  validates(:price, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_999_999.99 })
end
