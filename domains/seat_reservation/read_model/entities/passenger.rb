# frozen_string_literal: true

module SeatReservation
  module ReadModel
    module Entities
      class Passenger < ApplicationRecord
        self.table_name = 'passengers'
      end
    end
  end
end
