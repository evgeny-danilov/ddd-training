# frozen_string_literal: true

class SeatReservation
  class ReadModel
    def call(event)
      case event
      when SeatReservation::Events::PassengerDataEntered
        passenger_data_entered(event.data)
      end
    end

    private

    def passenger_data_entered(payload)
      Actions::CreatePassenger.new(
        stream_id: payload[:stream_id], 
        params: payload.dig(:params, :passenger)
      ).call
    end
  end
end
