# frozen_string_literal: true

module Route
  module Forms
    class RouteForm < Dry::Struct
      include Core::Form

      attribute :name, Types::String
      attribute :airline, Types::String
      attribute :departure_at, Types::Time
      attribute :arrival_at, Types::Time
    end
  end
end
