module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable_object, only: %i[vote_up vote_down destroy_vote render_response]
    before_action :set_vote, only: %i[vote_up vote_down destroy_vote]
  end

  def vote_up
    if @vote.nil?
      create_vote(1)
    end
  end

  def vote_down
    if @vote.nil?
      create_vote(-1)
    end
  end

  def destroy_vote
    @vote.delete if @vote.present?
    render_response
  end

  private

  def create_vote(value)
    @vote = @votable.votes.build(user: current_user, value: value)
    if @vote.save
      render_response
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable_object
    @votable = model_klass.find(params[:id])
  end

  def set_vote
    @vote = @votable.votes.find_by(user: current_user)
  end

  def render_response
    if @votable.is_a?(Answer)
      render turbo_stream: turbo_stream.update(@votable, partial: @votable, locals: {resource: @votable})
    else
      render turbo_stream: turbo_stream.update('rating', partial: 'shared/vote', locals: {resource: @votable})
    end
  end
end
