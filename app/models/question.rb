class Question < ApplicationRecord
  include Votable
  include Commentable
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:sql])

  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  
  has_many_attached :files
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :links, allow_destroy: true,  reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_commit on: :create  do
    broadcast_append_to(
      partial: 'questions/question',
      locals:{question: self},
      target: 'all_questions'
    )
  end

  after_create :calculate_reputation
  after_create :get_subscription

  def set_best_answer(answer)
    transaction do
      update!(best_answer: answer)
      reward&.update!(user: answer.user)
    end
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def get_subscription
    subscriptions.create(user: user)
  end
end
