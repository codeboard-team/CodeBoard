class CommentsController < ApplicationController
  def create
    @card = Card.find(params[:card_id])
    @comment = @card.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      redirect_to 'cards/card_solved'
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
