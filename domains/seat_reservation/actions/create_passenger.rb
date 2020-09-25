class SeatReservation
  module Actions
    class CreatePassenger
      def initialize(stream_name:, params:)
        @form = Forms::PassengerForm.new(params)
      end

      def call
        Entities::Passenger.create(form.attributes)
      end

      private

      attr_reader :form
    end
  end
end
