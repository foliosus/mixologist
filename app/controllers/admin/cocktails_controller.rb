class Admin::CocktailsController < ApplicationController
  before_action :preload_validation_data, only: [:new, :edit]

  # GET /cocktails
  # GET /cocktails.xml
  def index
    unless Cocktail.any?
      redirect_to(new_cocktail_path) and return
    end

    @cocktails = Cocktail.full_recipe

    @search = SearchTerms.new(search_params.to_hash)
    if @search.terms.present?
      @cocktails = @cocktails.merge(@search.scope)
    end

    render "cocktails/index"
  end

  # GET /cocktails/1
  # GET /cocktails/1.xml
  def show
    @cocktail = Cocktail.full_recipe.find(params[:id])

    render "cocktails/show"
  end

  # GET /cocktails/new
  # GET /cocktails/new.xml
  def new
    @cocktail = Cocktail.new
  end

  # GET /cocktails/1/edit
  def edit
    @cocktail = Cocktail.full_recipe.find(params[:id])
  end

  # POST /cocktails
  # POST /cocktails.xml
  def create
    @cocktail = Cocktail.new(cocktail_params)

    if @cocktail.save
      redirect_to admin_cocktail_path(@cocktail), notice: "#{@cocktail.name} is now in the recipe book"
    else
      puts @cocktail.errors.inspect
      preload_validation_data
      render :new, status: :unprocessable_entity
    end
  end

  # PUT /cocktails/1
  # PUT /cocktails/1.xml
  def update
    @cocktail = Cocktail.find(params[:id])

    if @cocktail.update(cocktail_params)
      redirect_to admin_cocktail_path(@cocktail), notice: 'Cocktail was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /cocktails/1
  # DELETE /cocktails/1.xml
  def destroy
    @cocktail = Cocktail.find(params[:id])
    @cocktail.destroy

    redirect_to admin_cocktails_url, notice: "#{@cocktail.name} has been removed from the recipe book"
  end

  private def preload_validation_data
    @ingredients = Ingredient.all
    @garnishes = Garnish.all
    @units = Unit.all
  end

  private def cocktail_params
    params.require(:cocktail).permit(:name, :notes, :recipe_items_blob, :technique, garnish_ids: [])
  end

  private def search_params
    params[:search_terms].present? ? params.require(:search_terms).permit(:term_string) : {}
  end
end
