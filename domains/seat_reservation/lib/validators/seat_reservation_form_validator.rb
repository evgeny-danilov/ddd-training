# frozen_string_literal: true

module SeatReservation
  module Validators
    class SeatReservationFormValidator < Dry::Validation::Contract
      params do
        required(:number).filled(:integer)
        required(:flight_uuid).filled(:string)
      end
    end
  end
end
