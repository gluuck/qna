module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(&:value)
  end

  def vote_author?(user)
    votes.exists?(user: user)
  end
end
