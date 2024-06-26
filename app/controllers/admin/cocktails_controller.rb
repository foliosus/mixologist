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

    respond_to do |format|
      format.html { render "cocktails/index" }
    end
  end

  # GET /cocktails/1
  # GET /cocktails/1.xml
  def show
    @cocktail = Cocktail.full_recipe.find(params[:id])

    respond_to do |format|
      format.html { render "cocktails/show" }
    end
  end

  # GET /cocktails/new
  # GET /cocktails/new.xml
  def new
    @cocktail = Cocktail.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /cocktails/1/edit
  def edit
    @cocktail = Cocktail.full_recipe.find(params[:id])
  end

  # POST /cocktails
  # POST /cocktails.xml
  def create
    @cocktail = Cocktail.new(cocktail_params)

    respond_to do |format|
      if @cocktail.save
        format.html { redirect_to(admin_cocktail_path(@cocktail), notice: "#{@cocktail.name} is now in the recipe book") }
      else
        preload_validation_data
        format.html { render action: "new" }
      end
    end
  end

  # PUT /cocktails/1
  # PUT /cocktails/1.xml
  def update
    @cocktail = Cocktail.find(params[:id])

    respond_to do |format|
      if @cocktail.update(cocktail_params)
        format.html { redirect_to(admin_cocktail_path(@cocktail), notice: 'Cocktail was successfully updated.') }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /cocktails/1
  # DELETE /cocktails/1.xml
  def destroy
    @cocktail = Cocktail.find(params[:id])
    @cocktail.destroy

    respond_to do |format|
      format.html { redirect_to(admin_cocktails_url) }
    end
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
