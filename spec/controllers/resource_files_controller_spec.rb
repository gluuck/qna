require 'rails_helper'

RSpec.describe ResourceFilesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, :with_file, question: question, user: user) }

  describe 'DELETE #destroy' do

    context 'Author answers' do
      before { log_in(user) }

      it 'delete the attached file' do
        expect { delete :destroy, params: { id: answer.files.first } }
          .to change(answer.files, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer.files.first }
        expect(response).to render_template "shared/_resource_files", "answers/_answer"
      end
    end

    context 'Not author' do
      let(:not_author) { create :user }

      it 'tries to delete file' do
        log_in(not_author)
        expect { delete :destroy, params: { id: answer.files.first } }
          .to_not change(answer.files, :count)
      end
    end

    context 'Not registered user' do
      it 'tries to delete ' do
        expect { delete :destroy, params: { id: answer.files.first } }
          .to_not change(answer.files, :count)
      end
    end
  end
end
