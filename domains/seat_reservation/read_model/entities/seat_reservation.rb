# frozen_string_literal: true

module SeatReservation
  module ReadModel
    module Entities
      class SeatReservation < ApplicationRecord
        self.table_name = 'seat_reservations'
      end
    end
  end
end
