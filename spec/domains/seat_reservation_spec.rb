# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeatReservation do
  let(:id) { 1 }
  let(:event_store) { RailsEventStore::Client.new }
  let(:event_stream) { "SeatReservation$#{id}" }

  def publish_events(*event_classes)
    publish(*event_classes.map(&method(:an_event)))
      .in(event_store)
      .in_stream(event_stream)
  end

  context '#reserve' do
    subject { described_class.new(id).reserve }

    it 'publishes the Reserved event' do
      expect { subject }.to publish_events(SeatReservation::Events::Reserved)
    end
  end

  context '#create_passenger' do
    subject { described_class.new(id).create_passenger(params: params) }

    let(:params) { { passenger: { first_name: 'Gold', last_name: 'Man' } } }

    context 'when seat has not been reserved' do
      it 'raises an error' do
        expect { subject }.to raise_error(AggregateRootErrors::InvalidTransaction)
      end
    end

    context 'when seat was reserved before' do
      before do
        described_class.new(id).reserve
        expect(AdminMailer).to receive(:passenger_created)
          .with(a_hash_including(stream_id: id, passenger: an_instance_of(SeatReservation::Entities::Passenger)))
          .and_call_original
      end

      it 'publishes events' do
        expect { subject }.to(
          publish_events(
            SeatReservation::Events::PassengerDataEntered,
            SeatReservation::Events::PassengerCreated
          )
        )
      end

      it 'creates passenger' do
        expect { subject }.to change(SeatReservation::Entities::Passenger, :count).by(1)

        expect(SeatReservation::Entities::Passenger.last).to have_attributes(
          first_name: 'Gold',
          last_name: 'Man'
        )
      end
    end
  end
end
