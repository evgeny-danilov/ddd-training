# frozen_string_literal: true

require_relative 'aggregate_root/event_repository'

module Core
  module AggregateRoot
    def self.included(klass)
      klass.include ::AggregateRoot
    end

    InvalidTransactionError = Class.new(StandardError)

    #def event_repository
    #  EventRepository.new(aggregate_root_class: @aggregate_root_class)
    #end
  end
end
