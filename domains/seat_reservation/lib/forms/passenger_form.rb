# frozen_string_literal: true

module SeatReservation
  module Forms
    class PassengerForm < Dry::Struct
      include Core::Form

      attribute :first_name, Types::String
      attribute :last_name,  Types::String
    end
  end
end
