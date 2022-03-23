# frozen_string_literal: true

class HouseBooking < ApplicationRecord
  belongs_to :house

  validate :validate_dates

  private

  def validate_dates
    errors.add(:base, :wrong_dates) if check_in >= check_out
    errors.add(:base, :already_booked) if house.house_bookings.where(check_out: check_in..).present?
  end
end
