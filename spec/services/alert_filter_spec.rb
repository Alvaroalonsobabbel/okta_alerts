# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe AlertFilter do
  let(:alert) { create(:alert) }
  let(:user_auth) { create(:user_auth) }
  let(:group_add_actor_id) { create(:group_add_actor_id) }
  let(:group_add_target_id) { create(:group_add_target_id) }
  let(:group_add_actor_and_target_id) { create(:group_add_actor_and_target_id) }

  let(:alerts) { [alert, user_auth, group_add_actor_id, group_add_target_id, group_add_actor_and_target_id] }

  let(:filtered_alerts) { AlertFilter.new(event).filter }

  before { alerts }
  before { filtered_alerts }

  describe '#filter' do
    context 'with event that has no matching alerts' do
      let(:event_no_matches) do
        { eventType: 'user.account.update_password',
          actor: { id: 'id' },
          target: [{ id: '123' }, { id: '1234' }] }
      end

      let(:event) { event_no_matches }

      it 'returns with an empty array' do
        expect(filtered_alerts).to be_empty
      end
    end

    context 'event that matches a catch-all event type for group.user_membership.add' do
      let(:catch_all_group_add) do
        { eventType: 'group.user_membership.add',
          actor: { id: 'id' },
          target: [{ id: '123' }, { id: '1234' }] }
      end

      let(:event) { catch_all_group_add }

      it 'returns just one alert' do
        expect(filtered_alerts.count).to eq 1
      end

      it 'returns the alert multiple_events only' do
        expect(filtered_alerts[0]['description']).to eq('catch all sent to group.user_membership.add')
      end
    end

    context 'event that matches group.user_membership.add with a target id' do
      let(:target_id_group_add) do
        { eventType: 'group.user_membership.add',
          actor: { id: 'id' },
          target: [{ id: '00g15qwyvbN0geKuE417' }, { id: '1234' }] }
      end

      let(:event) { target_id_group_add }

      it 'returns just one alert' do
        expect(filtered_alerts.count).to eq 2
      end
    end

    context 'event that matches group.user_membership.add with a actor id' do
      let(:actor_id_group_add) do
        { eventType: 'group.user_membership.add',
          actor: { id: '00u9uvk5hs0tNwKFV417' },
          target: [{ id: '12' }, { id: '1234' }] }
      end

      let(:event) { actor_id_group_add }

      it 'returns just one alert' do
        expect(filtered_alerts.count).to eq 2
      end
    end

    context 'event that matches group.user_membership.add with a actor id and target id' do
      let(:target_and_actor_id_group_add) do
        { eventType: 'group.user_membership.add',
          actor: { id: '00u9u5qi3nF4eSHRf417' },
          target: [{ id: '00g52gjx5pF6NcMD0417' }, { id: '1234' }] }
      end

      let(:event) { target_and_actor_id_group_add }

      it 'returns just one alert' do
        expect(filtered_alerts.count).to eq 2
      end
    end

    context 'event that matches a catch-all event type for user.authentication.auth' do
      let(:catch_all_user_auth) do
        { eventType: 'user.authentication.auth',
          actor: { id: 'id' },
          target: [{ id: '123' }, { id: '1234' }] }
      end

      let(:event) { catch_all_user_auth }

      it 'returns with an empty array' do
        expect(filtered_alerts.count).to eq 1
      end

      it 'returns the event_type of the event' do
        expect(filtered_alerts[0]['event_type']).to eq('user.authentication.auth')
      end
    end
  end
end
