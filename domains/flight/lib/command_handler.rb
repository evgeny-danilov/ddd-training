# frozen_string_literal: true

module Flight
  class CommandHandler
    def self.new_resource(uuid:)
      AggregateRoot.new(uuid)
    end

    def self.load_resource(uuid:)
      AggregateRoot.new(uuid).fetch
    end

    def self.schedule(uuid:, params:)
      ActiveRecord::Base.transaction do
        AggregateRoot.new(uuid).schedule(params: params)
      end
    end

    def self.cancel(uuid:)
      ActiveRecord::Base.transaction do
        AggregateRoot.new(uuid).cancel
      end
    end
  end
end
