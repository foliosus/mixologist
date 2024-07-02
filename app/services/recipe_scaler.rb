class RecipeScaler
  attr_reader :scale

  def initialize(cocktail, scale: 4)
    @cocktail = cocktail
    @scale = scale&.to_i || 1
    @scale = 1 if @scale < 1
  end

  def cocktail
    scaled_cocktail
  end

  private def scaled_cocktail
    return @scaled_cocktail if @scaled_cocktail
    @scaled_cocktail = @cocktail.clone
    @scaled_cocktail.recipe_items.each{|ri| ri.amount *= scale; ri.convert_to_cups! }
    @scaled_cocktail
  end
end
