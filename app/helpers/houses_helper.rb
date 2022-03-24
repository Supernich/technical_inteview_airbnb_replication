# frozen_string_literal: true

module HousesHelper
  def check_in_range(house)
    cur_date = Date.current
    { min: ((house.last_check_out_date || cur_date) + 1.days), max: (cur_date + 1.year) }
  end

  def check_out_range(house)
    cur_date = Date.current
    { min: ((house.last_check_out_date || cur_date) + 2.days), max: (cur_date + 1.year) }
  end
end
