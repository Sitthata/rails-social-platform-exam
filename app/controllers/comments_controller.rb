class CommentsController < ApplicationController
  def create
    @post = Post.find(params.expect(:post_id))
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post, anchor: "comments"), notice: "Comment was successfully created.", status: :see_other
    else
      @comments = @post.comments.includes(:user).order(:created_at, :id)
      @activities = Activity.for_post(@post).preload(:user, :trackable).newest_first
      render "posts/show", status: :unprocessable_content
    end
  end

  private

    def comment_params
      params.expect(comment: [ :body ])
    end
end
