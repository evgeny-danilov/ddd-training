# frozen_string_literal: true

FactoryBot.define do
  factory :route, class: Route::ReadModel::RouteReadModel::Table do
    sequence(:name) { |n| "QT-#{n}" }
    airline { 'QatarAirways' }
    departure_at { Time.parse('12:05PM') }
    arrival_at { Time.parse('14:37PM') }
  end
end
