# frozen_string_literal: true

module Route
  module ReadModel
    class RouteReadModel
      class RouteAR < ApplicationRecord
        self.table_name = 'routes'
      end

      def all
        RouteAR.all
      end

      def build(attributes = {})
        RouteAR.new(attributes)
      end
    end
  end
end
