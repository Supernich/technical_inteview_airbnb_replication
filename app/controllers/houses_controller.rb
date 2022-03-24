# frozen_string_literal: true

class HousesController < ApplicationController
  before_action :set_house, only: %i[show edit update destroy]
  before_action :assign_filters, only: :index

  def index
    @houses = HousesSearchService.filter_houses(@filters)
  end

  def show
    @bookings = @house.house_bookings.from_check_out_date(Date.current)
  end

  def new
    @house = House.new
  end

  def edit; end

  def create
    @house = House.new(house_params)

    if @house.save
      redirect_to house_url(@house), notice: 'House was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @house.update(house_params)
      redirect_to house_url(@house), notice: 'House was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @house.destroy

    redirect_to houses_url, notice: 'House was successfully destroyed.'
  end

  private

  def set_house
    @house = House.find(params[:id])
  end

  def house_params
    params.require(:house).permit(:country, :city, :name, :description, :address, :price)
  end

  def assign_filters
    @country = params[:country]
    @city = params[:city]
    @check_in = params[:check_in]
    @check_out = params[:check_out]

    @filters = { country: @country, city: @city, check_in: @check_in, check_out: @check_out }
  end
end
