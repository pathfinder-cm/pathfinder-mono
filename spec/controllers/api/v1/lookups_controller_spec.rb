require 'rails_helper'

::RSpec.describe ::Api::V1::LookupsController do
  it 'responds with index' do
    get :index, format: :json
    lookup = {}
    expect(response.body).to eq(::Api::V1::LookupSerializer.new(object: lookup).to_h.to_json)
  end

  it 'responds with ping' do
    get :ping, format: :json
    res = JSON.parse(response.body)
    expect(res['message']).to eq('OK')
    expect(DateTime.strptime(res['time'], '%Q')).to be_within(1.seconds).of(DateTime.current)
  end
end
