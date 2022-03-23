class VotePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def vote_up?
    user&.present? #&& !user.author?(record)
  end  

  def destroy_vote?
    user&.present? 
  end
  
  def vote_down?
    user&.present?
  end 
end