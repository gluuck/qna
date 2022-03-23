class ResourceFilesController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    authorize file.record
    file.purge 
    render turbo_stream: turbo_stream.remove(file)
  end
end
