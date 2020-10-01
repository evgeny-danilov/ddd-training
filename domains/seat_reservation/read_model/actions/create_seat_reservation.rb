# frozen_string_literal: true

module SeatReservation
  module ReadModel
    module Actions
      class CreateSeatReservation
        def initialize(stream_id:, params:)
          @stream_id = stream_id
          @form = Forms::SeatReservationForm.new(params)
        end

        def call
          validate!
          new_reservation.tap do |seat_reservation|
            seat_reservation.save
            broadcast_event(seat_reservation: seat_reservation)
          end
        end

        private

        attr_reader :form, :validator, :stream_id

        def validate!
          validator = Validators::SeatReservationFormValidator.new.call(form.attributes)
          return if validator.success?

          raise Core::Forms::Error, errors: validator.errors, object: new_reservation
        end

        def new_reservation
          Entities::SeatReservation.new(form.attributes)
        end

        def broadcast_event(seat_reservation:)
        end
      end
    end
  end
end
