require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { {"ACCEPT" => "application/json"} }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) {'/api/v1/questions'}
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) {create(:user)}
      let(:access_token) { create :access_token }
      let(:questions) {create_list(:question, 3)}
      let!(:question) {questions.first}
      let(:question_response) {json['questions'].first}
      let!(:answers) {create_list(:answer, 3, question: question)}
      before { get api_path, params:{ access_token: access_token.token}}

      it "return status 200" do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(json.size).to eq 3
      end

      it "return all publick fields" do
        %w(id title body user_id).each do |attr|
        expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it "contents short title" do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      it "contains user object" do
        expect(question_response['user_id']).to eq question.user.id
      end

      describe 'answers' do
        let(:answer) {answers.first}
        let(:answer_response) {question_response['answers'].first}

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it "return all publick fields" do
          %w(id body user_id).each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
