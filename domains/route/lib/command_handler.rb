# frozen_string_literal: true

module Route
  class CommandHandler
    include Core::CommandHandler::Helpers

    InvalidParameters = Class.new(StandardError)

    def create(params:)
      form = Forms::RouteForm.new(params)
      assert(form, validator: Validators::RouteFormValidator.new)
      route = ReadModel::RouteReadModel.new.build(form.attributes)

      transaction { Command.save(route) }
    end
  end
end
