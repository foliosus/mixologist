# Service class responsible for dumping the entire database to a JSON file,
# to enable backup-style operations.

class DataDumper
  def initialize
    @timestamp = Time.now.to_i
  end

  def to_json!
    all_data_hash = {
      "units" => Unit.all.collect(&:to_hash),
      "ingredient_categories" => IngredientCategory.all.collect(&:to_hash),
      "ingredients" => Ingredient.all.collect(&:to_hash),
      "garnishes" => Garnish.all.collect(&:to_hash),
      "cocktails" => Cocktail.full_recipe.all.collect(&:to_hash)
    }

    File.open(Rails.root / "db" / "cocktails.json", 'w') do |file|
      file.write(JSON.pretty_generate(all_data_hash))
    end

    puts "updated db/cocktails.json. Don't forget to commit the changes!"

    return true
  rescue => e
    puts e.message
    puts e.backtrace
    return false
  end
end
