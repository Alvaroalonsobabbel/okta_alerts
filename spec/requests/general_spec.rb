# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe 'General', type: :request do
  before { get '/something' }
  it 'returns 404 for a non-declared endpoint' do
    expect(last_response.status).to eq 404
  end
end
