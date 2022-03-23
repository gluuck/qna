class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @link = Link.find(params[:id])
    authorize (@link.linkable)
    @link.delete
    render turbo_stream: turbo_stream.remove(@link)    
  end
end
