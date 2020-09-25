class SeatReservation
  module Events
    class SeatReserved          < RailsEventStore::Event; end
    class PassengerDataEntered  < RailsEventStore::Event; end
    class PassengerCreated      < RailsEventStore::Event; end
    class SeatPaid              < RailsEventStore::Event; end
  end
end
