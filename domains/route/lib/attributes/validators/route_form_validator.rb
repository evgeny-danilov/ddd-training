# frozen_string_literal: true

module Route
  module Attributes
    module Validators
      class RouteFormValidator < Dry::Validation::Contract
        params do
          required(:name).filled(:string)
          required(:airline).filled(:string)
          required(:departure_at).filled(:time)
          required(:arrival_at).filled(:time)
        end
      end
    end
  end
end
