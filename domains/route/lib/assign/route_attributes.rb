# frozen_string_literal: true

module Route
  module Assign
    class RouteAttributes
      def initialize(object:, params:)
        @form = Forms::RouteForm.new(params)
        @validator = Validators::RouteFormValidator.new
        @object = object
      end

      def call
        validator.call(form.attributes).tap do |result|
          raise Core::Forms::Error, errors: result.errors, object: object if result.failure?
        end

        object.assign_attributes(form.attributes)
      end

      private

      attr_reader :form, :validator, :object
    end
  end
end
