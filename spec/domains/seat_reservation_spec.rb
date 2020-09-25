# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeatReservation do
  let(:id) { 1 }
  let(:event_store) { RailsEventStore::Client.new }
  let(:event_stream) { "SeatReservation$#{id}" }

  def publish_event(event_class)
    publish(an_event(event_class))
      .in(event_store)
      .in_stream(event_stream)
  end

  context '#reserve' do
    subject { described_class.new(id).reserve }

    it 'publishes the SeatReserved event' do
      expect { subject }.to publish_event(SeatReservation::Events::SeatReserved)
    end
  end

  context '#create_passenger' do
    subject { described_class.new(id).create_passenger(params: params) }

    let(:params) { { passenger: { first_name: 'Gold', last_name: 'Man' } } }

    context 'when seat has not been reserved' do
      it 'raises an error' do
        expect { subject }.to raise_error(SeatReservation::InvalidTransaction)
      end
    end

    context 'when seat was reserved before' do
      before do
        described_class.new(id).reserve
      end

      it 'publishes the PassengerDataEntered event' do
        expect { subject }.to(
          change(SeatReservation::Entities::Passenger, :count).by(1).and(
            publish_event(SeatReservation::Events::PassengerDataEntered)
          )
        )

        expect(SeatReservation::Entities::Passenger.last).to have_attributes(
          first_name: 'Gold',
          last_name: 'Man'
        )
      end
    end
  end
end
