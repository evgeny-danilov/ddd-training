# frozen_string_literal: true

module Notification
  module ReadModel
    class Subscribers
      def call(event)
        case event
        when SeatReservation::Events::PassengerAdded
          passenger_added(event.data)
        end
      end

      private

      def passenger_added(payload)
        # TODO: Find Flight No and pass it to mailer
        AdminMailer.passenger_added(payload).deliver_later
      end
    end
  end
end
