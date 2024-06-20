class IngredientCategoriesController < ApplicationController
  before_action :set_ingredient_category, only: [:edit, :update, :destroy]

  # GET /ingredient_categories
  def index
    @ingredient_categories = IngredientCategory.all
  end

  # GET /ingredient_categories/new
  def new
    @ingredient_category = IngredientCategory.new
  end

  # GET /ingredient_categories/1/edit
  def edit
  end

  # POST /ingredient_categories
  def create
    @ingredient_category = IngredientCategory.new(ingredient_category_params)

    if @ingredient_category.save
      redirect_to ingredient_categories_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ingredient_categories/1
  def update
    if @ingredient_category.update(ingredient_category_params)
      redirect_to ingredient_categories_path, notice: "Category was successfully updated to #{@ingredient_category.name}."
    else
      render :edit
    end
  end

  # DELETE /ingredient_categories/1
  def destroy
    @ingredient_category.destroy
    redirect_to ingredient_categories_path, notice: 'Category was successfully destroyed.'
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_ingredient_category
    @ingredient_category = IngredientCategory.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  private def ingredient_category_params
    params.require(:ingredient_category).permit(:name)
  end
end
