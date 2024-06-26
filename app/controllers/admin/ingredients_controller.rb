class Admin::IngredientsController < ApplicationController
  # GET /ingredients
  # GET /ingredients.xml
  def index
    @ingredients = if params[:ingredient_category]
      @ingredient_category = IngredientCategory.find(params[:ingredient_category])
      @ingredient_category.ingredients.all
    else
      Ingredient.includes(:ingredient_category).all
    end

    if @ingredients.blank?
      redirect_to new_admin_ingredient_path, notice: 'No ingredients were found. Create the first one now!'
    end
  end

  # GET /ingredients/new
  # GET /ingredients/new.xml
  def new
    preload_validation_data
    @ingredient = Ingredient.new
  end

  # GET /ingredients/1/edit
  def edit
    @ingredient = Ingredient.find(params[:id])
    preload_validation_data
  end

  # POST /ingredients
  # POST /ingredients.xml
  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      redirect_to admin_ingredients_path, notice: "#{@ingredient.name} has been added to the pantry"
    else
      preload_validation_data
      render :new, status: :unprocessable_entity
    end
  end

  # PUT /ingredients/1
  # PUT /ingredients/1.xml
  def update
    @ingredient = Ingredient.find(params[:id])

    if @ingredient.update(ingredient_params)
      redirect_to admin_ingredients_path, notice: 'Ingredient was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ingredients/1
  # DELETE /ingredients/1.xml
  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy

    redirect_to(admin_ingredients_url, notice: "#{@ingredient.name} has been deleted")
  end

  private def ingredient_params
    params.require(:ingredient).permit(:name, :notes, :ingredient_category_id)
  end

  private def preload_validation_data
    @cocktails = @ingredient.try(:cocktails)
    @ingredient_categories = IngredientCategory.all
  end
end
