# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Alert, type: :model do
  it { should validate_presence_of(:event_type) }
  it { should validate_presence_of(:slack_webhook) }
  it { should have_db_index(:event_type) }

  it 'has a valid alerts factory' do
    expect(build(:alert)).to be_valid
  end
end
