require "rails_helper"

RSpec.describe SeatReservation do
  let(:id) { 1 }
  let(:event_store) { RailsEventStore::Client.new }
  let(:event_stream) { "SeatReservation$#{id}" }

  # context 'when #reserve action called' do
  #   subject { described_class.new.reserve }

  #   it 'creates an event without publishing' do
  #     expect(subject).to contain_exactly(SeatReservation::Events::SeatReserved)
  #   end
  # end

  context 'when #reserve action called' do
    subject { described_class.new(id).reserve }

    it 'publishing an event SeatReserved' do
      expect { subject }.to publish(
        an_event(SeatReservation::Events::SeatReserved)
      ).in(event_store).in_stream(event_stream)
    end
  end

  context 'when #payment_pending action called' do
    subject { described_class.new(id).payment_pending }

    it 'publishing an event SeatPaymentPending' do
      expect { subject }.to raise_error(SeatReservation::InvalidTransaction)
    end

    context 'when seat was reserved before' do
      before do 
        described_class.new(id).reserve
      end

      it 'publishing an event SeatPaymentPending' do
        expect { subject }.to publish(
          an_event(SeatReservation::Events::SeatPaymentPending)
        ).in(event_store).in_stream(event_stream)
      end
    end
  end
end