# frozen_string_literal: true

require_relative 'seat_reservation/lib/events'

Dir['domains/seat_reservation/lib/**/*.rb'].each { |file| require File.join('./', file) }
