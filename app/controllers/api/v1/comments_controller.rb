class Api::V1::CommentsController < ApiController
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :set_current_user_comment, only: %i[update destroy
                                                    liking_users]
  before_action :set_comment, only: %i[show like_comment unlike_comment]
  wrap_parameters :comment, include: %i[post user body]

  def index
    @comments = Post.find(params[:post_id]).comments
                    .page(params[:page])
                    .order("created_at DESC")
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render :show, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def show; end

  def update
    if @comment.update(comment_params)
      render :show, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.destroy
      render :show, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def like_comment
    if @current_user.like_comment! @comment
      @comment.update_likes_count
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  def unlike_comment
    if @current_user.unlike_comment! @comment
      @comment.update_likes_count
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  def liking_users
    render json: @comment.liking_users.to_a, status: :ok
  end

  private

  def comment_params
    { user_id: @current_user.id,
      post_id: params[:post_id],
      body: params[:body] }
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_current_user_comment
    @comment = @current_user.comments.find(params[:id])
  end
end
