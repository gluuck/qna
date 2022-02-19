class ResourceFilesController < ApplicationController
  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    file.purge if current_user.author?(file.record)
    render turbo_stream: turbo_stream.remove(file)
  end
end
