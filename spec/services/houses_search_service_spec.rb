# frozen_string_literal: true

RSpec.describe HousesSearchService do
  include ActiveSupport::Testing::TimeHelpers

  before do
    travel_to(Date.new(2022, 3, 23))

    house1 = create(:house, name: 'house1', country: 'Country1', city: 'City1')
    house2 = create(:house, name: 'house2', country: 'Country1', city: 'City2')
    create(:house, name: 'house3', country: 'Country2', city: 'City2')
    create(:house, name: 'house4', country: 'Country2', city: 'City3')

    create(:house_booking, house: house1, check_in: Date.new(2022, 3, 10), check_out: Date.new(2022, 3, 25))
    create(:house_booking, house: house1, check_in: Date.new(2022, 3, 28), check_out: Date.new(2022, 3, 30))
    create(:house_booking, house: house2, check_in: Date.new(2022, 3, 28), check_out: Date.new(2022, 3, 30))
  end

  describe '#filter_houses' do
    it 'returns filtered houses by provided country' do
      expect(
        described_class.filter_houses(
          { country: 'country2', city: 'city2', check_in: Date.new(2022, 3, 23), check_out: Date.new(2022, 3, 28) },
          House.all
        ).as_json(only: :name)
      ).to(eq([{ 'name' => 'house3' }]))
    end
  end

  describe '#filter_by_country' do
    it 'returns filtered houses by provided country' do
      expect(described_class.filter_by_country('country1', House.all).as_json(only: :name))
        .to(eq([{ 'name' => 'house1' }, { 'name' => 'house2' }]))
    end

    it 'returns filtered houses by provided country even if country name not full' do
      expect(described_class.filter_by_country('try1', House.all).as_json(only: :name))
        .to(eq([{ 'name' => 'house1' }, { 'name' => 'house2' }]))
    end
  end

  describe '#filter_by_city' do
    it 'returns filtered houses by provided city' do
      expect(described_class.filter_by_city('city2', House.all).as_json(only: :name))
        .to(eq([{ 'name' => 'house2' }, { 'name' => 'house3' }]))
    end

    it 'returns filtered houses by provided city even if city name not full' do
      expect(described_class.filter_by_city('ty2', House.all).as_json(only: :name))
        .to(eq([{ 'name' => 'house2' }, { 'name' => 'house3' }]))
    end
  end

  describe '#filter_by_check_in_date' do
    it 'returns filtered houses by provided check_in date' do
      expect(described_class.filter_by_check_in_date(Date.new(2022, 3, 24), House.all).as_json(only: :name))
        .to(eq([{ 'name' => 'house3' }, { 'name' => 'house4' }]))
    end
  end

  describe '#filter_by_check_out_date' do
    it 'returns filtered houses by provided check_out date' do
      expect(described_class.filter_by_check_out_date(Date.new(2022, 3, 29), House.all).as_json(only: :name))
        .to(eq([{ 'name' => 'house3' }, { 'name' => 'house4' }]))
    end
  end
end
