# frozen_string_literal: true

require_relative 'aggregate_root/event_repository'

module Core
  module AggregateRoot
    def self.included(klass)
      klass.include ::AggregateRoot
    end

    InvalidTransactionError = Class.new(StandardError)

    def fetch
      event_repository.fetch(id)
    end

    private

    def resource
      return @resource if defined?(@resource)

      event_repository.with_id(id) { return @resource = _1 }
    end

    def broadcast(event_class, payload)
      event = event_class.strict(payload.merge(stream_id: id))
      Rails.configuration.event_store.publish(event, stream_name: stream_name)

      event
    end

    def event_repository
      EventRepository.new(aggregate_root_class: self.class)
    end
  end
end
