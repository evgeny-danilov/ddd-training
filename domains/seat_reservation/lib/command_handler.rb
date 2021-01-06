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

    def create(uuid:, params:)
      form = Forms::SeatReservationForm.new(params)
      assert(form, validator: Validators::SeatReservationFormValidator.new)

      transaction { AggregateRoot.new(uuid).create(form: form) }
    end

    def add_passenger(uuid:, params:)
      form = Forms::PassengerForm.new(params)
      assert(form, validator: Validators::PassengerFormValidator.new)

      transaction { AggregateRoot.new(uuid).add_passenger(form: form) }
    end

    def paid(uuid:)
      transaction { AggregateRoot.new(uuid).paid }
    end

    # def create(uuid:, params:)
    #  ActiveRecord::Base.transaction do
    #    EventRepository.new.with_id(uuid) do |resource|
    #      resource.create(params: params)
    #    end
    #  end
    # end
    #
    # def add_passenger(uuid:, params:)
    #  ActiveRecord::Base.transaction do
    #    EventRepository.new.with_id(uuid) do |resource|
    #      resource.add_passenger(params: params)
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
