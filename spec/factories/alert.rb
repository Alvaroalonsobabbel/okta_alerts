# frozen_string_literal: true

FactoryBot.define do
  factory :alert, class: Alert do
    event_type { 'group.user_membership.add' }
    slack_webhook { 'some_hook' }
    description { 'catch all sent to group.user_membership.add' }
  end

  factory :user_auth, class: Alert do
    event_type { 'user.authentication.auth' }
    slack_webhook { 'some_hook' }
    description { 'should receive all events for user.authentication.auth' }
  end

  factory :group_add_actor_id, class: Alert do
    event_type { 'group.user_membership.add' }
    slack_webhook { 'some_hook' }
    actor_id { ['00u9uvk5hs0tNwKFV417'] }
    description { 'should receive events send to group.user_membership.add and actor id 00u9uvk5hs0tNwKFV417' }
  end

  factory :group_add_target_id, class: Alert do
    event_type { 'group.user_membership.add' }
    slack_webhook { 'some_hook' }
    target_id { ['00g15qwyvbN0geKuE417'] }
    description { 'should receive events send to group.user_membership.add and target id 00g15qwyvbN0geKuE417' }
  end

  factory :group_add_actor_and_target_id, class: Alert do
    event_type { 'group.user_membership.add' }
    slack_webhook { 'some_hook' }
    actor_id { ['00u9u5qi3nF4eSHRf417'] }
    target_id { ['00g52gjx5pF6NcMD0417'] }
    description do
      'should receive events send to group.user_membership.add and target id 00g52gjx5pF6NcMD0417 and actor id 00u9u5qi3nF4eSHRf417'
    end
  end
end
