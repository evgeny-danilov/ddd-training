# frozen_string_literal: true

class SeatReservationsController < ApplicationController
  # GET /index
  def index
    # @resources = seat_reservation_read_model.all
  end

  # GET /new
  def new
    @resource = SeatReservation::CommandHandler.new.new_resource(uuid: SecureRandom.uuid)
  end

  # POST /create
  def create
    SeatReservation::CommandHandler.new.create(uuid: resource_id, params: seat_params)

    redirect_to user_input_seat_reservation_url(reservation_id: resource_id)
  end

  # GET /user_input
  def user_input
    load_resource
  end

  # POST /add_passenger
  def add_passenger
    SeatReservation::CommandHandler.new.add_passenger(uuid: resource_id, params: passenger_params)

    redirect_to payment_confirm_seat_reservation_url(reservation_id: resource_id)
  end

  # GET /payment_confirm
  def payment_confirm
    load_resource
  end

  # POST /payment_done
  def payment_done
    SeatReservation::CommandHandler.new.paid(uuid: resource_id)

    redirect_to congratulate_seat_reservation_url(reservation_id: resource_id)
  end

  # GET /congratulate
  def congratulate
    load_resource
  end

  private

  def load_resource
    @resource = SeatReservation::CommandHandler.new.load_resource(uuid: resource_id)
  end

  def resource_id
    params[:reservation_id]
  end

  def passenger_params
    params[:passenger]
  end

  def seat_params
    params[:seat]
  end
end
