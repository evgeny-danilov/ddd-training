# frozen_string_literal: true

module Flight
  class CommandHandler
    include Core::CommandHandler::Helpers

    def new_resource(uuid:)
      AggregateRoot.new(uuid)
    end

    def load_resource(uuid:)
      AggregateRoot.new(uuid).fetch
    end

    def schedule(uuid:, params:)
      form = Forms::FlightForm.new(params)
      assert(form, validator: Validators::FlightFormValidator.new)

      transaction { AggregateRoot.new(uuid).schedule(form: form) }
    end

    def cancel(uuid:)
      transaction  { AggregateRoot.new(uuid).cancel }
    end
  end
end
