# frozen_string_literal: true

require_relative 'flight/lib/events'
Dir['domains/flight/lib/**/*.rb'].each { |file| require File.join('./', file) }
