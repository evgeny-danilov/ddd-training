# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flight::AggregateRoot do
  let(:flights_table) { Flight::ReadModel::FlightReadModel::Table }
  let(:routes_table) { Route::ReadModel::RouteReadModel::RouteAR }
  let(:uuid) { '12345' }

  let(:route) do
    routes_table.create(
      name: 'QT-123',
      airline: 'Qatar',
      departure_at: Date.current,
      arrival_at: Date.current
    )
  end

  def publish_events(*event_classes)
    publish(*event_classes.map(&method(:an_event)))
      .in(RailsEventStore::Client.new)
      .in_stream("Flight$#{uuid}")
  end

  context '#schedule' do
    subject { described_class.new(uuid).schedule(params: { uuid: uuid, route_id: route.id }) }

    it 'publishes the Scheduled event' do
      expect { subject }.to publish_events(Flight::Events::Scheduled)
    end

    it 'creates a flight' do
      expect { subject }.to change(flights_table.where(uuid: uuid), :count).by(1)
    end

    context 'when flight has already scheduled' do
      before { described_class.new(uuid).schedule(params: { uuid: uuid, route_id: route.id }) }

      it 'raises an error' do
        expect { subject }.to raise_error(Flight::AggregateRoot::InvalidTransactionError)
      end
    end
  end

  context '#cancel' do
    subject { described_class.new(uuid).cancel }

    let(:flight_params) { { uuid: uuid, route_id: route.id } }

    context 'when flight has not been scheduled' do
      it 'raises an error' do
        expect { subject }.to raise_error(Core::AggregateRoot::InvalidTransactionError)
      end
    end

    context 'when has been scheduled' do
      before do
        described_class.new(uuid).schedule(params: flight_params)
      end

      it 'publishes events' do
        expect { subject }.to publish_events(Flight::Events::Cancelled)
      end
    end
  end
end
