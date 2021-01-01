# frozen_string_literal: true

module Route
  module ReadModel
    class RouteReadModel
      class Table < ApplicationRecord
        self.table_name = 'routes'
      end

      def all
        Table.all
      end

      def build(attributes = {})
        Table.new(attributes)
      end
    end
  end
end
