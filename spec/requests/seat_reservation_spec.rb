# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Seat Reservation', type: :request do
  let(:reservation_id) { 123 }
  let(:seat_params) {  { number: 32 } }
  let(:aggregate_root) { SeatReservation::AggregateRoot.new(reservation_id) }

  context 'GET #new' do
    it 'shows new page' do
      get '/seat_reservation/new'
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST #reserve' do
    let(:params) { { reservation_id: reservation_id, seat: seat_params } }

    it 'redirects to user_input page' do
      post '/seat_reservation/reserve', params: params
      expect(response).to redirect_to(user_input_seat_reservation_url(reservation_id: reservation_id))
    end

    context 'when seat has been reserved' do
      before { post '/seat_reservation/reserve', params: params }

      it 'redirects to user_input page' do
        post '/seat_reservation/reserve', params: params
        expect(response).not_to redirect_to(user_input_seat_reservation_url(reservation_id: reservation_id))
      end
    end
  end

  context 'when seat has reserved' do
    before { aggregate_root.reserve(params: seat_params) }

    context 'GET #user_input' do
      let(:params) { { reservation_id: reservation_id } }

      it 'shows user_input page' do
        get '/seat_reservation/user_input', params: params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'POST #create_passenger' do
      let(:params) { { reservation_id: reservation_id, passenger: passenger_attributes } }
      let(:passenger_attributes) { { first_name: 'Gold', last_name: 'Man' } }

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
end
