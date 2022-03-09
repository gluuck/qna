class Question < ApplicationRecord
  include Votable

  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :links, allow_destroy: true,  reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def set_best_answer(answer)
    transaction do
      update!(best_answer: answer)
      reward&.update!(user: answer.user)
    end
  end
end
