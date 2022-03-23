# frozen_string_literal: true

class House < ApplicationRecord
  has_many :house_bookings, dependent: :destroy

  validates(:name, :country, :city, presence: true)
  validates(:price, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_999_999.99 })

  def last_check_out_date
    house_bookings.where(check_out: Date.current..).order(check_out: :desc).first&.check_out
  end

  def first_check_in_date
    house_bookings.where(check_in: Date.current..).order(check_in: :asc).first&.check_in
  end
end
