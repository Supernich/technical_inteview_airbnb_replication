# frozen_string_literal: true

class HouseBooking < ApplicationRecord
  belongs_to :house

  validate :validate_dates

  scope :from_check_in_date, ->(date) { where(check_in: date..) }
  scope :from_check_out_date, ->(date) { where(check_out: date..) }

  private

  def validate_dates
    errors.add(:base, :wrong_dates) if check_in >= check_out
    errors.add(:base, :already_booked) if house.house_bookings.where(check_out: check_in..).present?
  end
end
