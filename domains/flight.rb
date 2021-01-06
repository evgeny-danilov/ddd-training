# frozen_string_literal: true

Dir['domains/flight/lib/**/*.rb'].each { |file| require File.join('./', file) }
