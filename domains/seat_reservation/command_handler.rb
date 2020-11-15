# frozen_string_literal: true

module SeatReservation
  class CommandHandler
    def self.new_resource(uuid:)
      AggregateRoot.new(uuid)
    end

    def self.load_resource(uuid:)
      AggregateRoot.new(uuid).fetch
    end

    def self.reserve(uuid:, params:)
      AggregateRoot.new(uuid).reserve(params: params)
    end

    def self.create_passenger(uuid:, params:)
      AggregateRoot.new(uuid).create_passenger(params: params)
    end

    def self.paid(uuid:)
      AggregateRoot.new(uuid).paid
    end

    #def reserve(uuid:, params:)
    #  ActiveRecord::Base.transaction do
    #    EventRepository.new.with_id(uuid) do |resource|
    #      resource.reserve(params: params)
    #    end
    #  end
    #end
    #
    #def create_passenger(uuid:, params:)
    #  ActiveRecord::Base.transaction do
    #    EventRepository.new.with_id(uuid) do |resource|
    #      resource.create_passenger(params: params)
    #    end
    #  end
    #end
    #
    #def paid(uuid:, params:)
    #  ActiveRecord::Base.transaction do
    #    EventRepository.new.with_id(uuid) do |resource|
    #      resource.paid(params: params)
    #    end
    #  end
    #end
  end
end
