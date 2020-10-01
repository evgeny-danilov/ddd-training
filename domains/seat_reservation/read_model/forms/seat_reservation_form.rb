# frozen_string_literal: true

module SeatReservation
  module ReadModel
    module Forms
      module Types
        include Dry.Types()
      end

      class SeatReservationForm < Dry::Struct
        attribute :number, Types::Coercible::Integer
      end
    end
  end
end
