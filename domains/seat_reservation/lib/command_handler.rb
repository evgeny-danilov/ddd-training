# frozen_string_literal: true

module SeatReservation
  class CommandHandler
    include Core::CommandHandler::Helpers

    def new_resource(uuid:)
      AggregateRoot.new(uuid)
    end

    def load_resource(uuid:)
      AggregateRoot.new(uuid).fetch
    end

    def reserve(uuid:, params:)
      form = Forms::SeatReservationForm.new(params)
      assert(form, validator: Validators::SeatReservationFormValidator.new)

      transaction { AggregateRoot.new(uuid).reserve(params: form.attributes) }
    end

    def create_passenger(uuid:, params:)
      form = Forms::PassengerForm.new(params)
      assert(form, validator: Validators::PassengerFormValidator.new)

      transaction { AggregateRoot.new(uuid).create_passenger(params: form.attributes) }
    end

    def paid(uuid:)
      transaction { AggregateRoot.new(uuid).paid }
    end

    # def reserve(uuid:, params:)
    #  ActiveRecord::Base.transaction do
    #    EventRepository.new.with_id(uuid) do |resource|
    #      resource.reserve(params: params)
    #    end
    #  end
    # end
    #
    # def create_passenger(uuid:, params:)
    #  ActiveRecord::Base.transaction do
    #    EventRepository.new.with_id(uuid) do |resource|
    #      resource.create_passenger(params: params)
    #    end
    #  end
    # end
    #
    # def paid(uuid:, params:)
    #  ActiveRecord::Base.transaction do
    #    EventRepository.new.with_id(uuid) do |resource|
    #      resource.paid(params: params)
    #    end
    #  end
    # end
  end
end
