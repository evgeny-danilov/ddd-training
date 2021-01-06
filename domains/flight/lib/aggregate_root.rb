# frozen_string_literal: true

require_relative 'events'

module Flight
  class AggregateRoot
    include Core::AggregateRoot

    def initialize(id)
      @state = :initialized
      @id = id
    end

    attr_reader :state, :id

    def fetch
      event_repository.fetch(id)
    end

    def schedule(form:)
      raise InvalidTransactionError unless resource.state == :initialized

      broadcast(Events::Scheduled, { params: form.attributes })
    end

    def cancel
      raise InvalidTransactionError unless resource.state == :scheduled

      broadcast(Events::Cancelled, {})
    end

    on Events::Scheduled do |_event|
      @state = :scheduled
    end

    on Events::Cancelled do |_event|
      @state = :cancelled
    end

    def stream_name
      "Flight$#{id}"
    end

    private

    def resource
      return @resource if defined?(@resource)

      event_repository.with_id(id) { return @resource = _1 }
    end

    def broadcast(event_class, payload)
      event = event_class.strict(payload.merge(stream_id: id))
      event.tap { Publisher.broadcast(event, stream_name) }
    end

    def event_repository
      EventRepository.new(aggregate_root_class: self.class)
    end
  end
end
