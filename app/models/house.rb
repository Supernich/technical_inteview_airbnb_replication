# frozen_string_literal: true

class House < ApplicationRecord
  validates(:price, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_999_999.99 })

end
