# frozen_string_literal: true

module SeatReservation
  module Attributes
    module Forms
      module Types
        include Dry.Types()
      end

      class PassengerForm < Dry::Struct
        attribute :first_name, Types::String
        attribute :last_name,  Types::String
      end
    end
  end
end
