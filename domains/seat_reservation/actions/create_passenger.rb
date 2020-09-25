# frozen_string_literal: true

class SeatReservation
  module Actions
    class CreatePassenger
      def initialize(stream_name:, params:)
        @stream_name = stream_name
        @form = Forms::PassengerForm.new(params)
      end

      def call
        Entities::Passenger.create(form.attributes)
      end

      private

      attr_reader :form, :stream_name
    end
  end
end
