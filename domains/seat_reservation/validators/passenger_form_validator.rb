# frozen_string_literal: true

class SeatReservation
  module Validators
    class PassengerFormValidator < Dry::Validation::Contract
      params do
        required(:first_name).filled(:string)
        required(:last_name).filled(:string)
      end
    end
  end
end
