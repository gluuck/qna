require 'rails_helper'

shared_examples 'voted' do
  let(:user) { create :user }
  let(:votable_author) { create :user }
  let(:votable) { create(described_class.controller_name.singularize.underscore.to_sym, user: votable_author) }

  describe 'POST #like', js: true do
    context 'Authenticated user' do
      before { log_in(user) }

      context 'vote once' do
        before { put :vote_up, params: { id: votable }, format: :turbo }

        it "increments #{described_class.controller_name}'s vote" do
          expect(votable.vote_count).to eq 1
        end
      end

      context "can't votes twice" do
        before do
          post :vote_up, params: { id: votable }, format: :turbo
          post :vote_up, params: { id: votable }, format: :turbo
        end

        it "can't increments #{described_class.controller_name}'s vote twice" do
          expect(votable.vote_count).to eq 1
        end
      end

      context 'cancel' do
        before do
          post :vote_up, params: { id: votable }, format: :turbo
          post :vote_down, params: { id: votable }, format: :turbo
        end

        it "can cancel #{described_class.controller_name}'s like" do
          expect(votable.vote_count).to eq 0
        end
      end
    end

    context "vote his #{described_class.controller_name}" do
      before { log_in(votable_author) }

      it "can't increments #{described_class.controller_name}'s vote" do
        post :vote_up, params: { id: votable }, format: :turbo
        expect(votable.vote_count).to eq 0
        expect(response.status).to eq 422
      end
    end

    context 'Unauthenticated user' do
      it "can't vote #{described_class.controller_name}" do
        post :vote_up, params: { id: votable }, format: :turbo
        expect(votable.vote_count).to eq 0
      end
    end
  end

  describe 'POST #dislike' do
    context 'Authenticated user' do
      before { log_in(user) }

      context 'votes once' do
        before { post :vote_down, params: { id: votable }, format: :turbo }

        it "decrements #{described_class.controller_name}'s vote" do
          expect(votable.vote_count).to eq(-1)
        end
      end

      context "can't votes twice" do
        before do
          post :vote_down, params: { id: votable }, format: :turbo
          post :vote_down, params: { id: votable }, format: :turbo
        end

        it "can't decrements #{described_class.controller_name}'s vote twice" do
          expect(votable.vote_count).to eq(-1)
        end
      end

      context 'cancel' do
        before do
          post :dislike, params: { id: votable }, format: :json
          post :like, params: { id: votable }, format: :json
        end

        it "can cancel #{described_class.controller_name}'s like" do
          expect(votable.vote_count).to eq 0
        end
      end
    end

    context "vote his #{described_class.controller_name}" do
      before { login(votable_author) }

      it "can't decrements #{described_class.controller_name}'s vote" do
        post :dislike, params: { id: votable }, format: :turbo
        expect(votable.vote_count).to eq 0
        expect(response.status).to eq 422
      end
    end

    context 'Unauthenticated user' do
      it "can't vote #{described_class.controller_name}" do
        post :dislike, params: { id: votable }, format: :turbo
        expect(votable.vote_count).to eq 0
      end
    end
  end
end
