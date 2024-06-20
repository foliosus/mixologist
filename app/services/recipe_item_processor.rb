# This service object's function is to take in a Cocktail and an array of textual recipe
# item summaries, and returns a set of RecipeItem objects, updated/new as necessary
# the values in the list.

class RecipeItemProcessor
  # Takes in a Cocktail object, and an array of textual recipe item summaries.
  # Changes the Cocktail object's RecipeItem association
  def self.process(cocktail, recipe_items_text_list)
    return [] if recipe_items_text_list.blank?

    results = []

    recipe_items = recipe_items_text_list.collect{|text| RecipeItem.parse_from_string(text) }

    recipe_items.each do |recipe_item|
      if existing_item = cocktail.recipe_items.detect{|item| item.ingredient == recipe_item.ingredient}
        existing_item.amount = recipe_item.amount
        existing_item.unit = recipe_item.unit
        results << existing_item
      else
        results << recipe_item
      end
    end

    results
  end
end