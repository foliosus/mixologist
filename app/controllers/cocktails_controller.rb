class CocktailsController < ApplicationController
  # GET /cocktails
  # GET /cocktails.xml
  def index
    @cocktails = Cocktail.full_recipe

    @search = SearchTerms.new(search_params.to_hash)
    if @search.terms.present?
      @cocktails = @cocktails.merge(@search.scope)
    end
  end

  # GET /cocktails/1
  # GET /cocktails/1.xml
  def show
    @cocktail = Cocktail.full_recipe.find(params[:id])
    @scaler = ScaleFormBacker.new
    @scale = scaler_params[:scale].try(:to_i)

    if params[:scale] && (@scale > 0)
      @cocktail = RecipeScaler.new(@cocktail, scale: @scale).cocktail
    end
  end

  def show_scaled
    cocktail = Cocktail.full_recipe.find(params[:id])
    scale = scaler_params[:scale]
    scaler = ScaleFormBacker.new(scale)
    cocktail = RecipeScaler.new(cocktail, scale: scale.try(:to_i)).cocktail

    render partial: "scaled_recipe", locals: {
      scaler: scaler,
      cocktail: cocktail,
      show_scaled_recipe: true
    }
  end

  private def search_params
    params[:search_terms].present? ? params.require(:search_terms).permit(:term_string) : {}
  end

  private def scaler_params
    params[:scale_form_backer].present? ? params.require(:scale_form_backer).permit(:scale) : {}
  end
end
