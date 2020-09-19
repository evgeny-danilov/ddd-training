class SeatReservation
  module Events
    class SeatReserved       < RailsEventStore::Event; end
    class SeatPaymentPending < RailsEventStore::Event; end
    class SeatPaid           < RailsEventStore::Event; end
  end
end
