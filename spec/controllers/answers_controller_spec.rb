

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create(:answer, question: question, user: user) }


  describe 'POST #create' do
    before { log_in(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, question: question)}}
        .to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, question: question)}
        
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid, question: question) } }
        .to_not change(Answer, :count)
      end
      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid, question: question) }
        expect(response).to render_template('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { log_in(user) }

    context 'user is author' do
      let!(:answer) { create :answer, question: question, user: user }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'user is not author' do
      let(:other_user) { create :user }
      let(:other_question) { create :question, user: other_user }
      let!(:other_answer) { create :answer, question: other_question, user: other_user }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: other_answer } }.to_not change(other_question.answers, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: other_answer }
        expect(response).to redirect_to question_path(other_question)
      end
    end
  end
end