class ProfileBlueprint < Blueprinter::Base
  identifier :id

  fields :email, :admin
end
