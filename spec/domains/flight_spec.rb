# frozen_string_literal: true

require 'rails_helper'

path = Rails.root.join('domains/flight/spec')

Dir.glob("#{path}/**/*_spec.rb") { require _1 }
