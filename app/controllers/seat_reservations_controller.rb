# frozen_string_literal: true

class SeatReservationsController < ApplicationController
  # GET /new
  def new
    @seat_reservation = aggregate_root(nil)
  end

  # POST /reserve
  def reserve
    new_reservation_id = SecureRandom.uuid
    aggregate_root(new_reservation_id).reserve

    redirect_to user_input_seat_reservation_url(reservation_id: new_reservation_id)
  end

  # GET /user_input
  def user_input
    load_resource
  end

  # POST /create_passenger
  def create_passenger
    aggregate_root(resource_id).create_passenger(params: params.to_unsafe_h.deep_symbolize_keys)

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

  def load_resource
    @seat_reservation = aggregate_root(resource_id).fetch
  end

  def resource_id
    params[:reservation_id]
  end

  def aggregate_root(id)
    SeatReservation.new(id)
  end
end
