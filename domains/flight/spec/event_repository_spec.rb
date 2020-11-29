# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flight::EventRepository do
  let(:uuid) { '123' }
  let(:flight_params) { { uuid: uuid, route_id: route.id } }
  let(:stream_name) { "Flight$#{uuid}" }
  let(:event_store) { Rails.configuration.event_store }

  let(:routes_table) { Route::ReadModel::RouteReadModel::RouteAR }
  let(:route) do
    routes_table.create(
      name: 'QT-123',
      airline: 'Qatar',
      departure_at: Date.current,
      arrival_at: Date.current
    )
  end

  def store_event(event_name)
    described_class.new.with_id(uuid) do |item|
      item.public_send(event_name, params: flight_params)
    end
  end

  context 'storing event to the stream' do
    subject { store_event(event_name) }

    context '#schedule' do
      let(:event_name) { :schedule }

      it 'creates a new event' do
        expect { subject }
          .to change { event_store.read.stream(stream_name).count }.by(1)
      end
    end
  end

  context 'loading an object from the stream' do
    subject { described_class.new.fetch(uuid) }

    it 'builds a new Flight object' do
      expect(subject).to have_attributes(state: :initialized)
    end

    context 'when seat was scheduled' do
      before { store_event(:schedule) }

      it 'loads the existing Flight object' do
        expect(subject).to have_attributes(state: :scheduled)
      end
    end
  end
end
