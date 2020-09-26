# frozen_string_literal: true

module Dry
  module Validation
    class Result
      def error_messages
        errors(full: true).to_h.values.flatten
      end
    end
  end
end
