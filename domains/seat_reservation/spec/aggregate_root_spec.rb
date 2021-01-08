# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeatReservation::AggregateRoot do
  let(:id) { 123 }
  let(:seat_number) { 32 }
  let(:flight_uuid) { '12345' }
  let(:passenger_form_class) { SeatReservation::Forms::PassengerForm }
  let(:seat_reservation_form_class) { SeatReservation::Forms::SeatReservationForm }
  let(:passengers_table) { SeatReservation::ReadModel::PassengerReadModel::Table }
  let(:seat_reservations_table) { SeatReservation::ReadModel::SeatReservationReadModel::Table }

  def publish_events(*event_classes)
    publish(*event_classes.map(&method(:an_event)))
      .in(RailsEventStore::Client.new)
      .in_stream("SeatReservation^#{id}")
  end

  before do
    allow(Core::AggregateRoot::EventRepository).to receive(:new).and_call_original
    allow(Core::AggregateRoot::EventRepository).to receive(:new)
      .with(aggregate_root_class: Flight::AggregateRoot)
      .and_return(double(fetch: double(state: :scheduled)))
  end

  context '#create' do
    subject { described_class.new(id).create(form: form) }

    let(:form) { seat_reservation_form_class.new(flight_uuid: flight_uuid, number: seat_number) }

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
    subject { described_class.new(id).add_passenger(form: form) }

    let(:form) { passenger_form_class.new(passenger_params) }
    let(:passenger_params) { { first_name: 'Gold', last_name: 'Man' } }

    context 'when seat has not been created' do
      it 'raises an error' do
        expect { subject }.to raise_error(Core::AggregateRoot::InvalidTransactionError)
      end
    end

    context 'when seat has been created by guest' do
      before do
        seat_reservation_form = seat_reservation_form_class.new(flight_uuid: flight_uuid, number: seat_number)
        described_class.new(id).create(form: seat_reservation_form)
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
