# frozen_string_literal: true

class SeatReservation
  module Entities
    class Passenger < ApplicationRecord
      self.table_name = 'passengers'
    end
  end
end
