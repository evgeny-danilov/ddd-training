# frozen_string_literal: true

module SeatReservation
  module Actions
    class PassengerAttributes
      def initialize(params:)
        @form = Forms::PassengerForm.new(params)
        @validator = Validators::PassengerFormValidator.new
        @object = ReadModel::PassengerReadModel.new.build(form.attributes)
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
