# frozen_string_literal: true

Dir['domains/notification/lib/**/*.rb'].each { |file| require File.join('./', file) }
