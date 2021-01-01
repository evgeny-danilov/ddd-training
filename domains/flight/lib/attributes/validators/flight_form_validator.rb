# frozen_string_literal: true

module Flight
  module Attributes
    module Validators
      class FlightFormValidator < Dry::Validation::Contract
        params do
          required(:uuid).filled(:string)
          required(:route_id).filled(:integer)
          # required(:depatrure_at).filled(:datetime)
          # required(:arrival_at).filled(:datetime)
        end
      end
    end
  end
end
