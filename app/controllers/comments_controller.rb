class CommentsController < ApplicationController
  def create
    @user = User.find(params[:user_id])

    @comment = @user.comments.build(comment_params.merge(user: current_user))
  end

  if @comment.save
  else
    render "cards/card_solved"
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end

