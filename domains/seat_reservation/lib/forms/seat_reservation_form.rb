# frozen_string_literal: true

module SeatReservation
  module Forms
    class SeatReservationForm < Dry::Struct
      include Core::Form

      attribute :number, Types::Coercible::Integer
      attribute :flight_uuid, Types::Coercible::String
    end
  end
end
