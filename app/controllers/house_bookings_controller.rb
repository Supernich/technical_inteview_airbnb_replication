# frozen_string_literal: true

class HouseBookingsController < ApplicationController
  def create
    @booking = HouseBooking.new(booking_params)
    if @booking.save
      redirect_to house_url(@booking.house)
    else
      head(:unprocessable_entity)
    end
  end

  def destroy
    @booking = HouseBooking.find(params[:id])

    redirect_to house_url(@booking.house)
  end

  private

  def booking_params
    params.require(:house_booking).permit(:house_id, :check_in, :check_out)
  end
end
