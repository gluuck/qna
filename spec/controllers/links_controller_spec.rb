require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create :user }
  let!(:question) { create :question, user: user }
  let!(:question_link) { create :link, linkable: question }
  let!(:answer) { create :answer, question: question, user: user }
  let!(:answer_link) { create :link, linkable: answer }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { log_in(user) }

      context 'question' do
        context 'user is author' do
          it 'deletes link' do
            expect { delete :destroy, params: { id: question.links.first }, format: :js }
              .to change(question.links, :count).by(-1)
          end

          it 'renders current page' do
            delete :destroy, params: { id: question.links.first }, format: :js
            expect(response).to have_http_status(200)
          end
        end

        context 'user is not author' do
          let(:other_user) { create :user }
          let!(:other_question) { create :question, user: other_user }
          let!(:other_link) { create :link, linkable: other_question }

          it 'does not delete link' do
            expect { delete :destroy, params: { id: other_question.links.first }, format: :js }
              .to_not change(other_question.links, :count)
          end

          it 'renders status 204' do
            delete :destroy, params: { id: other_question.links.first }, format: :js
            expect(response).to have_http_status(204)
          end
        end
      end

      context 'answer' do
        context 'user is author' do
          it 'deletes link' do
            expect { delete :destroy, params: { id: answer.links.first }, format: :js }
              .to change(answer.links, :count).by(-1)
          end

          it 'renders current answer' do
            delete :destroy, params: { id: answer.links.first }, format: :js
            expect(response).to have_http_status(200)
          end
        end

        context 'user is not author' do
          let(:other_user) { create :user }
          let!(:other_answer) { create :answer, question: question, user: other_user }
          let!(:other_answer_link) { create :link, linkable: other_answer }

          it 'does not have delete link' do
            expect { delete :destroy, params: { id: other_answer.links.first }, format: :js }
              .to_not change(other_answer.links, :count)
          end

          it 'renders status 204' do
            delete :destroy, params: { id: other_answer.links.first }, format: :js
            expect(response).to have_http_status(204)
          end
        end
      end
    end

    context 'Unauthenticated user' do
      context 'question' do
        it "can't delete question's link" do
          expect { delete :destroy, params: { id: question.links.first }, format: :js }
            .to_not change(question.links, :count)
        end

        it 'renders not authorized' do
          delete :destroy, params: { id: question.links.first }, format: :js
          expect(response).to have_http_status(401)
        end
      end

      context 'answer' do
        it "can't delete answer's link" do
          expect { delete :destroy, params: { id: answer.links.first }, format: :js }
            .to_not change(answer.files, :count)
        end

        it 'renders not authorized' do
          delete :destroy, params: { id: answer.links.first }, format: :js
          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
