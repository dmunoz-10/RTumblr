class Api::V1::BlogsController < ApiController
  before_action :set_blog, except: :create
  wrap_parameters :blog, include: %i[user name description]

  def create
    @blog = @current_user.blogs.new(blog_params)
    if @blog.save
      render :show, status: :created
    else
      render json: @blogs.errors, status: :unprocessable_entity
    end
  end

  def update
    if @blog.update(blog_params)
      render :show, status: :ok
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @blog.destroy
      render :show, status: :ok
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  private

  def blog_params
    params.require(:blog).permit(:name, :description)
  end

  def set_blog
    @blog = @current_user.blogs.find(params[:id])
  end
end
