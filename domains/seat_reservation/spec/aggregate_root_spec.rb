# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeatReservation::AggregateRoot do
  let(:id) { 123 }
  let(:seat_number) { 32 }
  let(:event_store) { RailsEventStore::Client.new }
  let(:event_stream) { "SeatReservation$#{id}" }
  let(:passengers_table) { SeatReservation::ReadModel::PassengerReadModel::Table }
  let(:seat_reservations_table) { SeatReservation::ReadModel::SeatReservationReadModel::Table }

  def publish_events(*event_classes)
    publish(*event_classes.map(&method(:an_event)))
      .in(event_store)
      .in_stream(event_stream)
  end

  context '#create' do
    subject { described_class.new(id).create(params: { number: seat_number }) }

    it 'publishes the Reserved event' do
      expect { subject }.to publish_events(SeatReservation::Events::Created)
    end

    context 'when seat has already created by other passenger' do
      before { seat_reservations_table.create!(number: seat_number) }

      it 'raises an error' do
        expect { subject }.to raise_error(SeatReservation::AggregateRoot::SeatHasAlreadyReserved)
      end
    end
  end

  context '#add_passenger' do
    subject { described_class.new(id).add_passenger(params: passenger_params) }

    let(:passenger_params) { { first_name: 'Gold', last_name: 'Man' } }

    context 'when seat has not been created' do
      it 'raises an error' do
        expect { subject }.to raise_error(Core::AggregateRoot::InvalidTransactionError)
      end
    end

    context 'when seat has been created by guest' do
      before do
        described_class.new(id).create(params: { number: seat_number })
      end

      it 'publishes events' do
        expect { subject }.to publish_events(SeatReservation::Events::PassengerAdded)
      end

      it 'creates a passenger' do
        expect { subject }.to change(passengers_table.where(passenger_params), :count).by(1)
      end

      it 'notify an admin' do
        expect(AdminMailer).to receive(:passenger_added)
          .with(a_hash_including(stream_id: id, params: {
                                   first_name: passenger_params[:first_name],
                                   last_name: passenger_params[:last_name]
                                 }))
          .and_call_original

        subject
      end
    end
  end
end
