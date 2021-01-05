# frozen_string_literal: true

FactoryBot.define do
  factory :flight, class: Flight::ReadModel::FlightReadModel::Table do
    sequence(:uuid) { |n| "#{SecureRandom.uuid}-#{n}" }
    route
  end
end
