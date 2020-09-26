# frozen_string_literal: true

module Core
  module Forms
    class Error < StandardError
      def initialize(messages)
        @messages = messages
        super(messages)
      end

      attr_reader :messages
    end
  end
end
