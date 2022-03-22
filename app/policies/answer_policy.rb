class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def update?
    user&.admin? || user&.author?(record)
  end

  def destroy?
    user&.admin? || user&.author?(record)
  end

  def best_answer?
    user&.admin? || user&.author?(record&.question)
  end

  def new_comment?
    user&.present?
  end

  def create_comment?
    user&.present?
  end  
end