# frozen_string_literal: true

RSpec.describe HousesHelper, type: :helper do
  include ActiveSupport::Testing::TimeHelpers

  describe '#check_in_range' do
    let(:house) { create(:house) }

    it 'return date borders as current date to +1 year' do
      travel_to(Date.new(2022, 1, 15))
      expect(helper.check_in_range(house)).to(eq({ min: Date.new(2022, 1, 16), max: Date.new(2023, 1, 15) }))
      expect(helper.check_out_range(house)).to(eq({ min: Date.new(2022, 1, 17), max: Date.new(2023, 1, 15) }))
    end

    context 'house is booked' do
      before do
        travel_to(Date.new(2022, 1, 15))
        create(:house_booking, house: house, check_in: Date.new(2022, 1, 13), check_out: Date.new(2022, 1, 16))
        create(:house_booking, house: house, check_in: Date.new(2022, 1, 17), check_out: Date.new(2022, 1, 20))
        create(:house_booking, house: house, check_in: Date.new(2022, 1, 21), check_out: Date.new(2022, 1, 25))
      end

      it 'assigns date borders' do
        expect(helper.check_in_range(house)).to(eq({ min: Date.new(2022, 1, 26), max: Date.current + 1.year }))
        expect(helper.check_out_range(house)).to(eq({ min: Date.new(2022, 1, 27), max: Date.current + 1.year }))
      end
    end
  end
end
