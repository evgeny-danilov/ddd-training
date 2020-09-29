# frozen_string_literal: true

module Core
  module AggregateRoot
    def self.included(klass)
      klass.include ::AggregateRoot
    end

    InvalidTransactionError = Class.new(StandardError)
  end
end
