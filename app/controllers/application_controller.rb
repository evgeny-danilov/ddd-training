# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Core::Forms::Error,
              with: :form_validation_error
  rescue_from Core::AggregateRoot::InvalidTransactionError,
              with: :invalid_transaction_error

  private

  def form_validation_error(exception)
    redirect_back_after_error(message: exception.messages.join(', '))
  end

  def invalid_transaction_error
    redirect_back_after_error(message: 'Invalid Transaction')
  end

  def redirect_back_after_error(message:)
    flash[:alert] = message
    load_resource if defined?(load_resource) && resource_id.present?
    redirect_back(fallback_location: '/')
  end
end
