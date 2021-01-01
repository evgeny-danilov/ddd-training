# frozen_string_literal: true

module Route
  class CommandHandler
    InvalidParameters = Class.new(StandardError)

    class << self
      def create(params:)
        ActiveRecord::Base.transaction do
          route = ReadModel::RouteReadModel.new.build(
            Attributes::RouteAttributes.new(object: route, params: params).call
          )
          Command.save(route)
        end
      rescue Dry::Struct::Error => e
        raise InvalidParameters, e
      end
    end
  end
end
