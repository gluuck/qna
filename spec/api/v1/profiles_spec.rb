require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { {"ACCEPT" => "application/json"} }

  describe 'GET api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) {'/api/v1/profiles/me'}
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create :access_token, resource_owner_id: me.id }
      before { get api_path, params:{ access_token: access_token.token }, headers: headers }

      it "return status 200" do
        expect(response).to be_successful
      end

      it "return all publick fields" do
        %w(id email admin).each do |attr|
        expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it "does not return private fields" do
        %w(password encrypted_password).each do |attr|
        expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
