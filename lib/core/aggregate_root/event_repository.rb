# frozen_string_literal: true

module Core
  module AggregateRoot
    class EventRepository
      def initialize(aggregate_root_class:, event_store: Rails.configuration.event_store)
        @aggregate_root_class = aggregate_root_class
        @repository = aggregate_root_class::Repository.new(event_store)
      end

      def with_id(id, &block)
        aggregate, stream_name = domain_params(id)
        repository.with_aggregate(aggregate, stream_name, &block)
      end

      def fetch(id)
        aggregate, stream_name = domain_params(id)
        repository.load(aggregate, stream_name)
      end

      private

      attr_reader :aggregate_root_class, :repository

      def domain_params(id)
        obj = aggregate_root_class.new(id)

        [obj, obj.stream_name]
      end
    end
  end
end
