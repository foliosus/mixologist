class Admin::IngredientCategoriesController < ApplicationController
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
    @ingredient_category = IngredientCategory.find(params[:id])
  end

  # POST /ingredient_categories
  def create
    @ingredient_category = IngredientCategory.new(ingredient_category_params)

    if @ingredient_category.save
      redirect_to admin_ingredient_categories_path, notice: 'Category was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ingredient_categories/1
  def update
    @ingredient_category = IngredientCategory.find(params[:id])
    if @ingredient_category.update(ingredient_category_params)
      redirect_to admin_ingredient_categories_path, notice: "Category was updated to #{@ingredient_category.name}."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ingredient_categories/1
  def destroy
    @ingredient_category = IngredientCategory.find(params[:id])
    @ingredient_category.destroy
    redirect_to admin_ingredient_categories_path, notice: "#{@ingredient_category.name} category has been deleted"
  end

  # Only allow a trusted parameter "white list" through.
  private def ingredient_category_params
    params.require(:ingredient_category).permit(:name)
  end
end
