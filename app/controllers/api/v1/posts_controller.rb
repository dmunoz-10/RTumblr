class Api::V1::PostsController < ApiController
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :set_current_user_post, only: %i[update destroy]
  before_action :set_post, only: %i[show like_post unlike_post liking_users]
  wrap_parameters :post, include: %i[blog body private]

  def index
    @posts = Blog.find(params[:blog_id]).posts
                 .page(params[:page])
                 .order("updated_at DESC")
    @posts.each do |post|
      post.update_visits_count
    end
  end

  def create
    @post = @current_user.blogs.find(params[:blog_id])
                         .posts.new(post_params)
    if @post.save
      render :show, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def show
    @post.update_visits_count
  end

  def update
    if @post.update(post_params)
      render :show, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      render :show, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def like_post
    if @current_user.like_post! @post
      @post.update_likes_count
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  def unlike_post
    if @current_user.unlike_post! @post
      @post.update_likes_count
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  def liking_users
    render json: @post.liking_users.to_a, status: :ok
  end

  private

  def post_params
    params.require(:post).permit(:blog, :body, :private)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_current_user_post
    @post = @current_user.blogs.find(params[:blog_id])
                         .posts.find(params[:id])
  end
end
