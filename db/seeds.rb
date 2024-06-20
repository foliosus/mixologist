raw_records_path = Rails.root / "db" / "cocktails.json"
puts "** Loading cocktails from #{raw_records_path}"
raw_records = JSON.load_file(raw_records_path.to_s)
puts "   parsed the file"
cocktail_data = raw_records["cocktails"]
puts "   found #{cocktail_data.length} recipes"

Cocktail.transaction do
  cocktails = cocktail_data.collect do |cocktail_datum|
    recipe_items = cocktail_datum["recipe_items"].collect do |recipe_item|
      ingredient = Ingredient.find_or_initialize_by(
        recipe_item["ingredient"].except("ingredient_category"),
      )
      ingredient_category = recipe_item["ingredient"]["ingredient_category"]
      if ingredient_category != "null"
        ingredient.ingredient_category = IngredientCategory.find_or_initialize_by(recipe_item["ingredient"]["ingredient_category"])
      end

      unit = recipe_item["unit"] == "null" ? nil : Unit.find_or_initialize_by(recipe_item["unit"])

      RecipeItem.new(
        amount: recipe_item["amount"],
        unit: unit,
        ingredient: ingredient
      )
    end

    garnishes = cocktail_datum["garnishes"].collect do |garnish|
      Garnish.find_or_initialize_by(garnish)
    end

    Cocktail.create(
      name: cocktail_datum["name"],
      notes: cocktail_datum["notes"],
      technique: cocktail_datum["technique"],
      recipe_items: recipe_items,
      garnishes: garnishes
    )
  end

  unsaved_records = cocktails.reject(&:persisted?)

  if unsaved_records.blank?
    puts "   saved #{cocktails.length} records"
  else
    puts "** Couldn't save all of the records! The #{unsaved_records.length} problems:"
    unsaved_records.each do |cocktail|
      puts cocktail.inspect
      puts cocktail.errors.inspect
    end
    raise ActiveRecord::Rollback, "Not all of the records were valid!"
  end
end
