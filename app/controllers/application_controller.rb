# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Core::Forms::Error,
              with: :form_validation_error
  rescue_from Core::AggregateRoot::InvalidTransactionError,
              with: :invalid_transaction_error

  private

  def form_validation_error(exception)
    redirect_back_after_error(
      # full_message: exception.object_with_errors.errors.full_messages.join(', ')
      full_message: exception.full_messages.to_s # TODO: make it user-friendly
    )

    # TODO: try to show errors on the form:
    # referer = request.headers["Referer"]
    # previous_action_name = referer.scan(/\/#{controller_name.singularize}\/(.+)\?/).flatten.first
    # @resource = exception.object_with_errors
    # render previous_action_name
  end

  def invalid_transaction_error
    redirect_back_after_error(full_message: 'Invalid Transaction')
  end

  def redirect_back_after_error(full_message:)
    flash[:alert] = full_message
    load_resource if defined?(load_resource) && resource_id.present?
    redirect_back(fallback_location: '/')
  end

  def params
    super.to_unsafe_hash.deep_symbolize_keys
  end
end
