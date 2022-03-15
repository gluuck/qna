module Commented
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include RecordHelper

  included do
    before_action :authenticate_user!
    before_action :set_commentable, only: [:create_comment, :new_comment]
  end

  def new_comment
    @comment = @commentable.comments.new
  end

  def create_comment
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        comment = Comment.new
        format.turbo_stream{
          render turbo_stream: turbo_stream.replace( dom_id_for_records(@commentable, comment), partial: 'comments/form', locals:{comment: comment, commentable: @commentable} )
        }
      else
        format.turbo_stream{
          render turbo_stream: turbo_stream.replace( dom_id_for_records(@commentable, @comment), partial: 'comments/form', locals:{comment: @comment, commentable: @commentable} )
        }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end
