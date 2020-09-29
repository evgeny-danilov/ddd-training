# frozen_string_literal: true

module Core
  module Forms
    class Error < StandardError

      def initialize(errors:, object:)
        @errors = errors
        @object = object
        super('Invalid attributes')
      end

      def object_with_errors
        @object_with_errors ||= object.tap(&method(:add_errors))
      end

      private

      attr_reader :errors, :object

      def add_errors(object)
        errors.messages.each do |message|
          field = message.path.first
          text = message.text
          
          object.errors.add(field, text)
        end
      end

    end
  end
end
