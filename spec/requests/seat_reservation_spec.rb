# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Seat Reservation', type: :request do
  context 'GET #new' do
    it 'shows new page' do
      get '/seat_reservation/new'
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST #reserve' do
    let(:reservation_id) { 123 }
    let(:params) { { reservation_id: reservation_id } }

    it 'redirects to user_input page' do
      post '/seat_reservation/reserve', params: params
      expect(response).to redirect_to(user_input_seat_reservation_url(reservation_id: reservation_id))
    end

    context 'when seat has been reserved' do
      before { SeatReservation::AggregateRoot.new(reservation_id).reserve }

      it 'redirects to user_input page' do
        post '/seat_reservation/reserve', params: params
        expect(response).not_to redirect_to(user_input_seat_reservation_url(reservation_id: reservation_id))
      end
    end
  end

  context 'GET #user_input' do
    let(:reservation_id) { 123 }
    let(:params) { { reservation_id: reservation_id } }

    before { SeatReservation::AggregateRoot.new(reservation_id).reserve }

    it 'shows user_input page' do
      get '/seat_reservation/user_input', params: params
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST #create_passenger' do
    let(:reservation_id) { 123 }
    let(:params) { { reservation_id: reservation_id, passenger: passenger_attributes } }
    let(:passenger_attributes) { { first_name: 'Gold', last_name: 'Man' } }

    before { SeatReservation::AggregateRoot.new(reservation_id).reserve }

    it 'redirects to payment confirmation page' do
      post '/seat_reservation/create_passenger', params: params
      expect(response).to redirect_to payment_confirm_seat_reservation_url(reservation_id: reservation_id)
    end

    context 'when missing passenger data' do
      let(:passenger_attributes) { { first_name: 'Gold', last_name: '' } }

      it 'render user_input page' do
        post '/seat_reservation/create_passenger', params: params
        expect(response).not_to redirect_to payment_confirm_seat_reservation_url(reservation_id: reservation_id)
      end
    end
  end
end
