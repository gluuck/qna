class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user.admin? || user.author?(record)
  end

  def show?
    true     
  end

  def create?
    user.present?
  end

  def destroy?
    user.admin? || user.author?(record)
  end
end