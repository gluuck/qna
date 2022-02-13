class RemoveForeignKeyAnswersToQuestions < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :answers, :questions
  end
end
