# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Route::CommandHandler do
  let(:route_table) { Route::ReadModel::RouteReadModel::Table }

  describe '.create' do
    subject { described_class.new.create(params: params) }

    let(:params) do
      {
        name: 'QT-124',
        airline: 'QatarAirways',
        departure_at: Time.parse('12:05PM'),
        arrival_at: Time.parse('14:37PM')
      }
    end

    it 'creates a route' do
      expect { subject }.to change(route_table, :count).by(1)
      expect(route_table.find_by(name: params[:name])).to have_attributes(
        name: params[:name],
        airline: params[:airline]
      )
    end

    context 'when :name parameter is missing' do
      let(:params) { { airline: 'QatarAirways' } }

      it 'does not create a route' do
        expect { subject }.to raise_error(Dry::Struct::Error, /:name is missing/)
        expect(route_table.find_by(name: params[:name])).to be_nil
      end
    end

    context 'when :name parameter is invalid' do
      let(:params) do
        {
          name: '',
          airline: 'QatarAirways',
          departure_at: Time.parse('12:05PM'),
          arrival_at: Time.parse('14:37PM')
        }
      end

      it 'does not create a route' do
        expect { subject }.to raise_error(Core::Forms::Error, 'Invalid attributes')
        expect(route_table.find_by(name: params[:name])).to be_nil
      end
    end
  end
end
