class Api::V1::UsersController < ApiController
  before_action :set_user, except: %i[create show_me liked_posts
                                      liked_comments]
  skip_before_action :authenticate_request, only: %i[create show]
  wrap_parameters :user, include: %i[ first_name last_name username avatar
                                      gender email password
                                      password_confirmation birth_date
                                      phone_number ]

  def create
    @user = User.new(user_params)
    if @user.save
      render :show, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show; end

  def show_me
    @user = @current_user
    render :show, status: :ok
  end

  def update
    if @user.update(user_params)
      render :show, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render :show, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def follow
    if @current_user.follow! @user
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  def unfollow
    if @current_user.unfollow! @user
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  def leaders
    render json: @user.leaders.to_a, status: :ok
  end

  def followers
    render json: @user.followers.to_a, status: :ok
  end

  def liked_posts
    @posts = @current_user.liked_posts
    render "api/v1/posts/index", status: :ok
  end

  def liked_comments
    @comments = @current_user.liked_comments
    render "api/v1/comments/index", status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :avatar,
                                 :gender, :email, :password,
                                 :password_confirmation, :birth_date,
                                 :phone_number)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
