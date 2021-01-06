# frozen_string_literal: true

module Flight
  module Forms
    class FlightForm < Dry::Struct
      include Core::Form

      attribute :uuid, Types::String
      attribute :route_id, Types::Integer
      # attribute :departure_at,  Types::DateTime
      # attribute :arrival_at,  Types::DateTime
    end
  end
end
