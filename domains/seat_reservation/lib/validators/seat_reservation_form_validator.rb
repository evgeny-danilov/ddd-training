# frozen_string_literal: true

module SeatReservation
  module Validators
    class SeatReservationFormValidator < Dry::Validation::Contract
      params do
        required(:number).filled(:integer)
      end
    end
  end
end
