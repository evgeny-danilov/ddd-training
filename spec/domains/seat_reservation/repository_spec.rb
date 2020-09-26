# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeatReservation::Repository do
  let(:object_id) { 123 }
  let(:stream_name) { "SeatReservation$#{object_id}" }
  let(:event_store) { Rails.configuration.event_store }

  def store_event(event_name)
    described_class.new.with_id(object_id) do |item|
      item.public_send(event_name)
    end
  end

  context 'storing event to the stream' do
    subject { store_event(event_name) }

    context '#reserve' do
      let(:event_name) { :reserve }

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

    context 'when seat was reserved' do
      before { store_event(:reserve) }

      it 'loads the existing SeatReservation object' do
        expect(subject).to have_attributes(state: :reserved)
      end
    end
  end
end
