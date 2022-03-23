# frozen_string_literal: true

class HousesController < ApplicationController
  before_action :set_house, only: %i[show edit update destroy]

  def index
    @houses = House.all
  end

  def show
    @check_in_range = { min: ((@house.last_check_out_date || Date.current) + 1), max: (Date.current + 1.year) }
    @check_out_range = { min: ((@house.last_check_out_date || Date.current) + 2), max: (Date.current + 1.year) }

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
end
