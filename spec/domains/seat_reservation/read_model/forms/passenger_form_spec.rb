# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeatReservation::ReadModel::Forms::PassengerForm do
  subject { described_class.new(params) }

  context 'with valid params' do
    let(:params) { { first_name: 'First name', last_name: 'Last name' } }

    it 'returns form object' do
      expect(subject).to have_attributes(first_name: 'First name', last_name: 'Last name')
    end
  end

  context 'with invalid params' do
    let(:params) { { first_name: 'First name' } }

    it 'returns form object' do
      expect { subject }.to raise_error(Dry::Struct::Error)
    end
  end
end
