# frozen_string_literal: true

RSpec.describe House, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe '#last_check_out_date' do
    let(:house) { create(:house) }

    before do
      travel_to(Date.new(2022, 1, 15))
      create(:house_booking, house: house, check_in: Date.new(2022, 1, 13), check_out: Date.new(2022, 1, 16))
      create(:house_booking, house: house, check_in: Date.new(2022, 1, 17), check_out: Date.new(2022, 1, 20))
    end

    it 'returns last checkout date' do
      expect(house.last_check_out_date).to(eq(Date.new(2022, 1, 20)))
    end
  end

  describe '#first_check_in_date' do
    let(:house) { create(:house) }

    before do
      travel_to(Date.new(2022, 1, 15))
      create(:house_booking, house: house, check_in: Date.new(2022, 1, 13), check_out: Date.new(2022, 1, 16))
      create(:house_booking, house: house, check_in: Date.new(2022, 1, 17), check_out: Date.new(2022, 1, 20))
      create(:house_booking, house: house, check_in: Date.new(2022, 1, 21), check_out: Date.new(2022, 1, 25))
    end

    it 'returns first checkin date starting from today' do
      expect(house.first_check_in_date).to(eq(Date.new(2022, 1, 17)))
    end
  end
end
