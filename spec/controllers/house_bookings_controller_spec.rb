# frozen_string_literal: true

RSpec.describe HouseBookingsController, type: :controller do
  describe '#Create' do
    let(:house) { create(:house) }

    it 'doesnt create booking if check_out before check_in' do
      post(:create, params: { house_booking: { house_id: house.id, check_in: Date.new(2022, 2, 1), check_out: Date.new(2022, 1, 1) } })
      expect(response.status).to(eq(422))
    end

    context 'house already booked' do
      before { create(:house_booking, house: house, check_in: Date.new(2022, 1, 1), check_out: Date.new(2022, 1, 15)) }

      it 'doesnt create booking if house booked in new booking period' do
        post(:create, params: { house_booking: { house_id: house.id, check_in: Date.new(2022, 1, 13), check_out: Date.new(2022, 1, 20) } })
        expect(response.status).to(eq(422))
      end

      it 'creates booking if they doesnt intersect' do
        expect(
          post(:create, params: { house_booking: { house_id: house.id, check_in: Date.new(2022, 1, 16), check_out: Date.new(2022, 1, 20) } })
        ).to(redirect_to(house_url(house)))
      end
    end
  end
end
