# frozen_string_literal: true

module Flight
  module Attributes
    module Forms
      module Types
        include Dry.Types()
      end

      class FlightForm < Dry::Struct
        attribute :uuid, Types::String
        attribute :route_id, Types::Integer
        # attribute :departure_at,  Types::DateTime
        # attribute :arrival_at,  Types::DateTime
      end
    end
  end
end
