# frozen_string_literal: true

module SeatReservation
  module Attributes
    class SeatReservationAttributes
      def initialize(params:)
        @form = Forms::SeatReservationForm.new(params)
        @validator = Validators::SeatReservationFormValidator.new
        @object = ReadModel::SeatReservationReadModel.new.build(form.attributes)
      end

      def call
        validator.call(form.attributes).tap do |result|
          raise Core::Forms::Error, errors: result.errors, object: object if result.failure?
        end

        form.attributes
      end

      private

      attr_reader :form, :validator, :object
    end
  end
end
