# frozen_string_literal: true

RSpec.describe HousesController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers

  describe '#index' do
    before do
      travel_to(Date.new(2022, 3, 23))

      create(:house, name: 'house1', country: 'Country1', city: 'City1')
      create(:house, name: 'house2', country: 'Country2', city: 'City2')
    end

    it 'assigns filtered houses by provided country' do
      get(:index, params: { country: 'country1' })

      expect(assigns(:houses).as_json(only: :name)).to(eq([{ 'name' => 'house1' }]))
    end
  end

  describe '#show' do
    let(:house) { create(:house) }

    it 'assigns date borders' do
      current_date = Date.new(2022, 1, 15)
      travel_to(current_date)
      get(:show, params: { id: house.id })

      expect(assigns(:check_in_range)).to(eq({ min: Date.new(2022, 1, 16), max: Date.new(2023, 1, 15) }))
      expect(assigns(:check_out_range)).to(eq({ min: Date.new(2022, 1, 17), max: Date.new(2023, 1, 15) }))
    end

    context 'house is booked' do
      before do
        travel_to(Date.new(2022, 1, 15))
        create(:house_booking, house: house, check_in: Date.new(2022, 1, 13), check_out: Date.new(2022, 1, 16))
        create(:house_booking, house: house, check_in: Date.new(2022, 1, 17), check_out: Date.new(2022, 1, 20))
        create(:house_booking, house: house, check_in: Date.new(2022, 1, 21), check_out: Date.new(2022, 1, 25))
      end

      it 'assigns date borders' do
        get(:show, params: { id: house.id })

        expect(assigns(:check_in_range)).to(eq({ min: Date.new(2022, 1, 26), max: Date.current + 1.year }))
        expect(assigns(:check_out_range)).to(eq({ min: Date.new(2022, 1, 27), max: Date.current + 1.year }))
      end
    end
  end

  describe '#Create' do
    context 'validates fields' do
      it 'doesnt create house with empty name' do
        post(:create, params: { house: { country: FFaker::Address.country, city: FFaker::Address.city, price: 100 } })
        expect(response.status).to(eq(422))
      end

      it 'doesnt create house with empty country' do
        post(:create, params: { house: { name: FFaker::Name.name, city: FFaker::Address.city, price: 100 } })
        expect(response.status).to(eq(422))
      end

      it 'doesnt create house with empty city' do
        post(:create, params: { house: { name: FFaker::Name.name, country: FFaker::Address.country, price: 100 } })
        expect(response.status).to(eq(422))
      end

      it 'doesnt create house with price less than 0' do
        post(:create, params: { house: { name: FFaker::Name.name, country: FFaker::Address.country, city: FFaker::Address.city, price: -1 } })
        expect(response.status).to(eq(422))
      end

      it 'doesnt create house with price higher than or equal to 10 billions' do
        post(
          :create, params: {
            house: { name: FFaker::Name.name, country: FFaker::Address.country, city: FFaker::Address.city, price: 9_999_999_999.991 }
          }
        )
        expect(response.status).to(eq(422))
      end

      it 'saves house with valid fields' do
        post(:create, params: { house: { name: FFaker::Name.name, country: FFaker::Address.country, city: FFaker::Address.city, price: 100 } })
        expect(response).to(redirect_to(assigns(:house)))
      end
    end
  end
end
