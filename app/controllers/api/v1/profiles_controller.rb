class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    respond_with ProfileBlueprint.render(current_resource_owner)
  end

  def all
    all_users = User.where.not(id: current_resource_owner.id)
    respond_with ProfileBlueprint.render(all_users)
  end
end
