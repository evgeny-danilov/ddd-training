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
      "Flight^#{id}"
    end
  end
end
