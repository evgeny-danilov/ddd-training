# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeatReservation::EventRepository do
  let(:object_id) { 123 }
  let(:seat_params) { { flight_uuid: '12345', number: 32 } }
  let(:stream_name) { "SeatReservation$#{object_id}" }
  let(:event_store) { Rails.configuration.event_store }
  let(:seat_reservation_form) { SeatReservation::Forms::SeatReservationForm.new(seat_params) }

  def store_event(event_name)
    described_class.new.with_id(object_id) do |item|
      item.public_send(event_name, form: seat_reservation_form)
    end
  end

  before do
    allow(Flight::ReadModel::FlightReadModel).to receive(:new).and_return(double(scheduled?: true))
  end

  context 'storing event to the stream' do
    subject { store_event(event_name) }

    context '#create' do
      let(:event_name) { :create }

      it 'creates a new event' do
        expect { subject }
          .to change { event_store.read.stream(stream_name).count }.by(1)
      end
    end
  end

  context 'loading an object from the stream' do
    subject { described_class.new.fetch(object_id) }

    it 'builds a new SeatReservation object' do
      expect(subject).to have_attributes(state: :initialized)
    end

    context 'when seat was created' do
      before { store_event(:create) }

      it 'loads the existing SeatReservation object' do
        expect(subject).to have_attributes(state: :created)
      end
    end
  end
end
