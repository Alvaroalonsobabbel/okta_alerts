# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe AlertsController, type: :request do
  let(:alert) { create(:alert) }
  let(:user_auth) { create(:user_auth) }
  let(:group_add_actor_id) { create(:group_add_actor_id) }

  let(:alerts) { [alert, user_auth, group_add_actor_id] }

  let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{ENV['ALERTS_API_KEY']}" } }

  describe 'GET /alerts' do
    before { alerts }

    context 'default behaviour' do
      before { get '/alerts', nil, headers }

      it 'receives HTTP status 200' do
        expect(last_response).to be_ok
      end

      it 'receives a json with the "data" root key' do
        expect(json_body['data']).to_not be nil
      end

      it 'receives all 3 alerts' do
        expect(json_body['data'].count).to eq 3
      end
    end
  end

  describe 'GET /alerts/:id' do
    context 'with existing resource' do
      before { get "/alerts/#{alert.id}", nil, headers }

      it 'gets HTTP status 200' do
        expect(last_response.status).to eq 200
      end

      it 'receives the "rails_tutorial" book as JSON' do
        expected = { data: alert }
        expect(last_response.body).to eq(expected.to_json)
      end
    end

    context 'with nonexistent resource' do
      it 'gets HTTP status 404' do
        get '/alerts/2314323', nil, headers
        expect(last_response.status).to eq 404
      end
    end
  end

  describe 'POST /alerts' do
    before { post '/alerts', body.to_json, headers }

    context 'with valid data' do
      let(:body) do
        { data: attributes_for(:alert) }
      end

      it 'gets HTTP status 201' do
        expect(last_response.status).to eq 201
      end

      it 'receives the newly created resource' do
        expect(json_body['data']['slack_webhook']).to eq 'some_hook'
      end

      it 'adds a record in the database' do
        expect(Alert.count).to eq 1
      end
    end

    context 'with missing event_type_key' do
      let(:body) do
        { data: { actor_id: ['some actor'], slack_webhook: '123123' } }
      end

      it 'gets HTTP status 422' do
        expect(last_response.status).to eq 422
      end

      it 'receives the error details' do
        expect(json_body['error']).to eq('Validation failed: Event type can\'t be blank')
      end

      it 'does not add a record in the database' do
        expect(Alert.count).to eq 0
      end
    end

    context 'with missing slack_webhook key' do
      let(:body) do
        { data: { event_type: 'some type' } }
      end

      it 'gets HTTP status 422' do
        expect(last_response.status).to eq 422
      end

      it 'receives the error details' do
        expect(json_body['error']).to eq('Validation failed: Slack webhook can\'t be blank')
      end

      it 'does not add a record in the database' do
        expect(Alert.count).to eq 0
      end
    end

    context 'passing an invalid data block' do
      let(:body) do
        { datta: { fake_param: 'some type' } }
      end

      it 'gets HTTP status 422' do
        expect(last_response.status).to eq 422
      end

      it 'receives the error details' do
        expect(json_body['error']).to eq('Main \'data\' object is missing.')
      end
    end

    context 'passing an invalid parameter inside data' do
      let(:body) do
        { data: { fake_param: 'some type' } }
      end

      it 'gets HTTP status 422' do
        expect(last_response.status).to eq 422
      end

      it 'receives the error details' do
        expect(json_body['error']).to eq(
          'No valid params present: event_type, actor_id, target_id, slack_webhook, description'
        )
      end
    end
  end

  describe 'PATCH /alerts/:id' do
    before { alerts }
    before { patch "/alerts/#{alert.id}", body.to_json, headers }

    context 'with valid data' do
      let(:body) do
        { data: { slack_webhook: 'newhook' } }
      end

      it 'gets HTTP status 200' do
        expect(last_response.status).to eq 200
      end

      it 'receives the updated resource' do
        expect(json_body['data']['slack_webhook']).to eq 'newhook'
      end

      it 'only updates the submitted param' do
        expect(json_body['data']['event_type']).to eq 'group.user_membership.add'
      end
    end

    context 'updating a mandatory field with emtpy information' do
      let(:body) do
        { data: { event_type: '' } }
      end

      it 'gets HTTP status 422' do
        expect(last_response.status).to eq 422
      end

      it 'receives the error details' do
        expect(json_body['error']).to eq('Validation failed: Event type can\'t be blank')
      end

      it 'does not modify the record in the database' do
        unmodified_alert = Alert.where(id: alert.id)
        expect(unmodified_alert[0]['event_type']).to eq('group.user_membership.add')
      end
    end

    context 'passing an invalid data block' do
      let(:body) do
        { datta: { fake_param: 'some type' } }
      end

      it 'gets HTTP status 422' do
        expect(last_response.status).to eq 422
      end

      it 'receives the error details' do
        expect(json_body['error']).to eq('Main \'data\' object is missing.')
      end
    end
  end

  describe 'DELETE /alerts' do
    before { post '/alerts', body.to_json, headers }
    let(:body) do
      { data: attributes_for(:alert) }
    end

    context 'with existing resource' do
      before { delete '/alerts/1', nil, headers }

      it 'gets HTTP status 204' do
        expect(last_response.status).to eq 204
      end

      it 'deletes the alert from the database' do
        expect(Alert.count).to eq 0
      end
    end

    context 'with nonexistent resource' do
      it 'gets HTTP status 404' do
        delete '/alerts/2109348120934', nil, headers
        expect(last_response.status).to eq 404
      end
    end
  end
end
