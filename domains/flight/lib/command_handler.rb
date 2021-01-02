# frozen_string_literal: true

module Flight
  class CommandHandler
    include Core::CommandHandler

    def new_resource(uuid:)
      AggregateRoot.new(uuid)
    end

    def load_resource(uuid:)
      AggregateRoot.new(uuid).fetch
    end

    def schedule(uuid:, params:)
      form = Forms::FlightForm.new(params)
      assert(form, validator: Validators::FlightFormValidator.new)

      transaction { AggregateRoot.new(uuid).schedule(params: form.attributes) }
    end

    def cancel(uuid:)
      transaction  { AggregateRoot.new(uuid).cancel }
    end
  end
end
