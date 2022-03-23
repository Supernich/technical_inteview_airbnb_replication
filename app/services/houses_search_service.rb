# frozen_string_literal: true

class HousesSearchService
  class << self
    def filter_houses(filters, houses = House.all)
      houses = filter_by_country(filters[:country], houses) if filters[:country].present?
      houses = filter_by_city(filters[:city], houses) if filters[:city].present?
      houses = filter_by_check_in_date(filters[:check_in], houses) if filters[:check_in].present?
      houses = filter_by_check_out_date(filters[:check_out], houses) if filters[:check_out].present?
      houses
    end

    def filter_by_country(country, houses)
      houses.where("country like '%#{country}%'")
    end

    def filter_by_city(city, houses)
      houses.where("city like '%#{city}%'")
    end

    def filter_by_check_in_date(check_in_date, houses)
      houses.reject { |house| house.last_check_out_date.present? && house.last_check_out_date > check_in_date.to_date }
    end

    def filter_by_check_out_date(check_out_date, houses)
      houses.reject { |house| house.first_check_in_date.present? && house.first_check_in_date <= check_out_date.to_date }
    end
  end
end
