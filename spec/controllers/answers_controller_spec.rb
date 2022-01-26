require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) {create(:question)} 

  describe 'POST #create' do
    context 'with valid atributes' do
      it 'save a new answer in the database' do
        expect{post :create, params: {answer: attributes_for(:answer, question: question), question_id: question}}.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: {answer: attributes_for(:answer, question: question), question_id: question}
        expect(response).to redirect_to question_answers_path
      end
    end

    context 'with invalid atributes' do
      it 'does not save question' do
        expect{post :create, params: {answer: attributes_for(:answer, :invalid, question: question), question_id: question}}.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: {answer: attributes_for(:answer, :invalid, question: question), question_id: question}
        expect(response).to render_template :new
      end
    end
  end

end