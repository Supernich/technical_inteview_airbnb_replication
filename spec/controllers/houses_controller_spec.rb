# frozen_string_literal: true

RSpec.describe HousesController, type: :controller do
  describe '#Create' do
    context 'validates price' do
      it 'doesnt create house with price less than 0 and 10 billions' do
        post(:create, params: { house: { price: -1 } })

        expect(response.status).to(eq(422))
      end

      it 'doesnt create house with price higher than or equal to 10 billions' do
        post(:create, params: { house: { price: 9_999_999_999.991 } })

        expect(response.status).to(eq(422))
      end

      it 'saves house with price in allowed range' do
        post(:create, params: { house: { price: 100 } })

        expect(response).to(redirect_to(assigns(:house)))
      end
    end
  end
end
