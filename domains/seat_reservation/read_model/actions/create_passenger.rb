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
          Command.save(passenger)
          after_save
        end

        private

        attr_reader :form, :validator, :stream_id

        def validate!
          validator = Validators::PassengerFormValidator.new.call(form.attributes)
          return if validator.success?

          raise Core::Forms::Error, errors: validator.errors, object: passenger
        end

        def passenger
          @passenger||= Entities::Passenger.new(form.attributes)
        end

        def after_save
          Publisher.broadcast(
            Events::PassengerCreated.new(data: { stream_id: stream_id, passenger: passenger })
          )
        end
      end
    end
  end
end
