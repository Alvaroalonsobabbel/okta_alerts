# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe EventsController, type: :request do
  describe 'GET /events' do
    context 'normal behaviour' do
      before do
        get '/events', nil, { 'HTTP_X_OKTA_VERIFICATION_CHALLENGE' => 'verified',
                              'HTTP_AUTHORIZATION' => "Bearer #{ENV['EVENTS_API_KEY']}" }
      end

      it 'gets HTTP response 200' do
        expect(last_response.status).to eq 200
      end

      it 'receives the verification header in the body' do
        expect(json_body['verification']).to eq('verified')
      end
    end

    context 'without authentication' do
      before { get '/events' }

      it 'gets HTTP response 401' do
        expect(last_response.status).to eq 401
      end

      it 'gets an error body' do
        expect(json_body['error']).to eq('Invalid Events API key')
      end
    end
  end

  describe 'POST /events' do
    before { post '/events', nil, { 'HTTP_AUTHORIZATION' => "Bearer #{ENV['EVENTS_API_KEY']}" } }

    it 'gets HTTP response 200' do
      expect(last_response.status).to eq 200
    end
  end

  context 'without authentication' do
    before { post '/events' }

    it 'gets HTTP response 401' do
      expect(last_response.status).to eq 401
    end

    it 'gets an error body' do
      expect(json_body['error']).to eq('Invalid Events API key')
    end
  end
end
