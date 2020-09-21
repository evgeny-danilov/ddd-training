require "rails_helper"

RSpec.describe SeatReservationsController, type: :controller do
  
  context 'GET #new' do
    render_views

    it 'shows new page' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST #reserve' do
    let(:reservation_id) { 123 }
    
    before do
      expect(SecureRandom).to receive(:uuid).and_return(reservation_id).twice
    end

    it 'redirects to user_input page' do
      post :reserve
      expect(response).to redirect_to(user_input_seat_reservation_url(reservation_id: reservation_id))
    end

    context 'when seat has been reserved' do
      before { SeatReservation.new(reservation_id).reserve }

      it 'redirects to user_input page' do
        post :reserve
        expect(response).to render_template :new
      end
    end
  end

  context 'GET #user_input' do
    render_views

    let(:reservation_id) { 123 }

    before { SeatReservation.new(reservation_id).reserve }

    it 'shows user_input page' do
      get :user_input, params: { reservation_id: reservation_id }
      expect(response).to have_http_status(:ok)
    end
  end

end
