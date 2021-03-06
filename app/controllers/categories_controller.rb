class CategoriesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  before_action :require_admin, except: [:index, :show]
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    # Returns all categories for admin and only categories with articles for users
    # Categories are returned in order of number of articles associated with them
    if (user_signed_in? && current_user.admin?)
      @categories = Category.left_outer_joins(:articles).group('categories.id').order('count(articles.id) DESC').paginate(page: params[:page], per_page: 10)
    else
      @categories = Category.joins(:articles).group('categories.id').order('count(articles.id) DESC').paginate(page: params[:page], per_page: 10)
    end
  end

  def show
    @articles = @category.articles.order("created_at DESC").paginate(page: params[:page], per_page: 5)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save 
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to @category
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = "#{@category.name}'s was successfully deleted."
    redirect_to categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :image_url)
  end

  def require_admin
    if !(user_signed_in? && current_user.admin?)
      redirect_to categories_path
    end
  end

end
