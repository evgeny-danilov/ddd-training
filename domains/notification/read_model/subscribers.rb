# frozen_string_literal: true

module Notification
  module ReadModel
    class Subscribers
      def call(event)
        case event
        when SeatReservation::Events::PassengerCreated
          passenger_created(event.data)
        end
      end

      private

      def passenger_created(payload)
        AdminMailer.passenger_created(payload).deliver_later
      end
    end
  end
end
