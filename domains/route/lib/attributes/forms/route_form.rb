# frozen_string_literal: true

module Route
  module Attributes
    module Forms
      module Types
        include Dry.Types()
      end

      class RouteForm < Dry::Struct
        attribute :name, Types::String
        attribute :airline, Types::String
        attribute :departure_at, Types::Time
        attribute :arrival_at, Types::Time
      end
    end
  end
end
