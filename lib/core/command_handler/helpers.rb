# frozen_string_literal: true

module Core
  module CommandHandler
    module Helpers

      private

      def assert(form, validator:)
        validator.call(form.attributes).tap do |result|
          raise(Core::Forms::Error, errors: result.errors) if result.failure?
        end
      end

      def transaction(&block)
        ActiveRecord::Base.transaction(&block)
      end

    end
  end
end
