# frozen_string_literal: true

module SeatReservation
  module ReadModel
    module Actions
      class CreatePassenger
        def initialize(stream_id:, params:)
          @stream_id = stream_id
          @form = Forms::PassengerForm.new(params)
        end

        def call
          validate!
          new_passenger.tap do |passenger|
            passenger.save
            broadcast_event(passenger: passenger)
          end
        end

        private

        attr_reader :form, :validator, :stream_id

        def validate!
          validator = Validators::PassengerFormValidator.new.call(form.attributes)
          return if validator.success?

          raise Core::Forms::Error, errors: validator.errors, object: new_passenger
        end

        def new_passenger
          Entities::Passenger.new(form.attributes)
        end

        def broadcast_event(passenger:)
          Publisher.broadcast(
            Events::PassengerCreated.new(data: { stream_id: stream_id, passenger: passenger })
          )
        end
      end
    end
  end
end
