# frozen_string_literal: true

module SeatReservation
  module Events
    class Reserved              < RailsEventStore::Event; end
    class PassengerDataEntered  < RailsEventStore::Event; end
    class PassengerCreated      < RailsEventStore::Event; end
    class Paid                  < RailsEventStore::Event; end
  end
end
