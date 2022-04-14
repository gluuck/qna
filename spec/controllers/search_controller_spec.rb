require 'rails_helper'

RSpec.describe SphinxSearchController, type: :controller do
  describe 'GET #search' do
    before { get :search, params: { search_body: 'new search request', type: 'All' } }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'render template search' do
      expect(response).to render_template :search
    end
  end
end