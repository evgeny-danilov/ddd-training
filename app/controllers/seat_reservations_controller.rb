# frozen_string_literal: true

class SeatReservationsController < ApplicationController
  # GET /index
  def index
    # @resources = seat_reservation_read_model.all
  end

  # GET /new
  def new
    @resource = new_resource
  end

  # POST /reserve
  def reserve
    aggregate_root(resource_id).reserve(params: seat_params)

    redirect_to user_input_seat_reservation_url(reservation_id: resource_id)
  end

  # GET /user_input
  def user_input
    load_resource
  end

  # POST /create_passenger
  def create_passenger
    aggregate_root(resource_id).create_passenger(params: passenger_params)

    redirect_to payment_confirm_seat_reservation_url(reservation_id: resource_id)
  end

  # GET /payment_confirm
  def payment_confirm
    load_resource
  end

  # POST /payment_done
  def payment_done
    aggregate_root(resource_id).paid

    redirect_to congratulate_seat_reservation_url(reservation_id: resource_id)
  end

  # GET /congratulate
  def congratulate
    load_resource
  end

  private

  def aggregate_root(id)
    SeatReservation::AggregateRoot.new(id)
  end

  def new_resource
    aggregate_root(SecureRandom.uuid)
  end

  def load_resource
    return @resource if defined?(@resource)

    @resource = aggregate_root(resource_id).fetch
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
