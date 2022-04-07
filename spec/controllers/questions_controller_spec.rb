require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) {create(:question, user: user)}
  let(:user) { create(:user) }

  before { log_in(user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before {get :show, params: {id: question}}

    it 'render show view' do
      expect(response).to render_template :show
    end

    it 'assigns new link for question' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do

    before {get :new}

    it 'render show new' do
      expect(response).to render_template :new
    end

    it "assigns a new Question to @question" do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do
    before {get :edit, params: {id: question}}

    it 'render edit view' do
      expect(response).to render_template "questions/_form"
    end
  end

  describe 'POST #create' do

    context 'with valid atributes' do
      it 'save a new question in the database' do
        expect{post :create, params: {question: attributes_for(:question)}}.to change(Question, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid atributes'do
      it 'does not save question' do
        expect{post :create, params: {question: attributes_for(:question, :invalid)}}.to_not change(Question, :count)
      end
      it 're-render new view' do
        post :create, params: {question: attributes_for(:question, :invalid)}
        expect(response).to render_template('questions/_question_errors')
      end
    end

    context 'subscription' do
      it 'create with question' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(Subscription, :count).by(1)
      end

      it 'association with author question' do
        post :create, params: { question: attributes_for(:question) }
        expect(Question.first.subscriptions.first.user).to eq user
      end

      it 'can not create without question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .to_not change(Subscription, :count)
      end
    end
  end

  describe 'PATCH #update' do

    context 'with valid atributes' do
      before { log_in(user) }

      it 'assigns the request questions to @question' do
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(assigns(:question)).to eq question
      end

      it 'changes questions attributes' do
        patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}}
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirect to updated question' do
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(response).to render_template 'questions/_question_item'
      end
    end

    context 'with invalid atributes' do

      before {patch :update, params: {id: question, question: attributes_for(:question, :invalid)}, format: :js}

      it 'does not change question' do
        question.reload
        expect(question.title).to eq 'MyQuestion'
        expect(question.body).to eq 'QuestionText'
      end

      it 're-render edit view' do
        expect(response).to render_template 'questions/_question_errors'
      end
    end
  end

  describe 'DELETE #destroy' do

    let!(:question) {create(:question, user: user)}

    context 'user is author' do
      before { log_in(user) }

      it 'deletes the question' do
        expect{delete :destroy, params: {id: question}}.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'user is not author' do
      let!(:not_author) { create :user }

      before { log_in(not_author) }

      it 'cannot delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end
  end
end
