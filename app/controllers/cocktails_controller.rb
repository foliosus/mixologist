class CocktailsController < ApplicationController
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
      format.html # index.html.erb
    end
  end

  # GET /cocktails/1
  # GET /cocktails/1.xml
  def show
    @cocktail = Cocktail.full_recipe.find(params[:id])
    @scaler = ScaleFormBacker.new
    @scale = params[:scale].try(:to_i)

    if params[:scale] && (@scale > 0)
      @cocktail = RecipeScaler.new(@cocktail, scale: @scale).cocktail
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  private def search_params
    params[:search_terms].present? ? params.require(:search_terms).permit(:term_string) : {}
  end
end
