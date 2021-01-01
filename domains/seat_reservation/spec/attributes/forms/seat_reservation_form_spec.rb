# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeatReservation::Attributes::Forms::SeatReservationForm do
  subject { described_class.new(params) }

  context 'with valid params' do
    let(:params) { { number: '1' } }

    it 'returns form object' do
      expect(subject).to have_attributes(number: 1)
    end
  end

  context 'with invalid params' do
    let(:params) { { number: 'invalid' } }

    it 'returns form object' do
      expect { subject }.to raise_error(Dry::Struct::Error)
    end
  end
end
