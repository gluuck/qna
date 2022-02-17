class AddBestAnswerToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :best_answer, null: true 
  end
end
