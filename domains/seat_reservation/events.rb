# frozen_string_literal: true

class SeatReservation
  module Events
    class Reserved              < RailsEventStore::Event; end
    class PassengerDataEntered  < RailsEventStore::Event; end
    class PassengerCreated      < RailsEventStore::Event; end
    class SeatPaid              < RailsEventStore::Event; end
  end
end
