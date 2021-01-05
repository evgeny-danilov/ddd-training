# frozen_string_literal: true

FactoryBot.define do
  factory :seat_reservation, class: SeatReservation::ReadModel::SeatReservationReadModel::Table do
    number { 32 }
  end
end
