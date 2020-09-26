# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  default from: 'admin@example.com'
  layout 'mailer'

  def passenger_created(_payload)
    raise NotImplemented
  end
end
