class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @link = Link.find(params[:id])
    if current_user.author?(@link.linkable)
      @link.delete
      render turbo_stream: turbo_stream.remove(@link)
    end  
  end
end
