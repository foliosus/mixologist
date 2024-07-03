require 'test_helper'

class CocktailTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:recipe_items)
    should have_many(:ingredients).through(:recipe_items)
    should have_and_belong_to_many(:garnishes)
  end

  context "validations" do
    subject do
      build(:cocktail)
    end

    should validate_presence_of(:name)
    should validate_presence_of(:recipe_items_blob)
    should validate_inclusion_of(:technique).in_array(Cocktail.techniques)
  end

  context "with a blob description" do
    setup do
      @unit = create(:unit, abbreviation: 'oz')
      @recipe_item_strings = ["1 oz brandy", "1 oz lemon juice"]
      @blob = @recipe_item_strings.join("\r\n")
    end

    should "take a blob assignment to generate the RecipeItems" do
      cocktail = Cocktail.new
      cocktail.recipe_items_blob = @blob
      assert_equal @recipe_item_strings.length, cocktail.recipe_items.length, "Should have the right number of items"
    end

    should "return a blob when it has RecipeItems" do
      cocktail = Cocktail.new
      cocktail.recipe_items_blob = @blob
      assert_equal @recipe_item_strings.join("\n"), cocktail.recipe_items_blob
    end
  end

  context "full technique" do
    context "without garnishes" do
      setup do
        @cocktail = build(:cocktail, garnishes_count: 0)
      end
      should "just be the technique" do
        assert_equal "#{@cocktail.technique}", @cocktail.full_technique
      end
    end

    context "with garnishes" do
      setup do
        @cocktail = build(:cocktail, garnishes_count: 2)
      end
      should "be the technique with the garnishes" do
        garnishes_text = @cocktail.garnishes.collect{|g| "a #{g.name}"}.to_sentence
        expected = "#{@cocktail.technique}, garnish with #{garnishes_text}"
        assert_equal expected, @cocktail.full_technique
      end
    end
  end

  context "sort name" do
    setup do
      @cocktail = Cocktail.new
    end
    # Here we test with stop words (and, the), looking to remove them,
    # but not, e.g. "sand" which contains a stop word
    { 'The name' => 'name',
      'What the name' => 'what name',
      'What thename' => 'what thename',
      'Oil and water' => 'oil water',
      'Oil sand' => 'oil sand',
    }.each do |name, sort_name|
      should "correctly process #{name} for sorting" do
        @cocktail.name = name
        @cocktail.set_sort_name!
        assert_equal sort_name, @cocktail.sort_name
      end
    end
  end

  context "import/export" do
    should "serialize to hash" do
      cocktail = build(:cocktail, notes: "my notes")
      expected = {
        name: cocktail.name,
        notes: cocktail.notes,
        technique: cocktail.technique,
        recipe_items_blob: cocktail.recipe_items_blob,
        garnishes: cocktail.garnishes.collect(&:name)
      }
      assert_equal expected, cocktail.to_hash
    end

    should "import from hash" do
      ounce = create(:unit, name: "ounce", abbreviation: "oz")
      base_spirit = create(:ingredient_category, :base_spirit)
      gin = create(:ingredient, name: "gin", ingredient_category: base_spirit)
      bourbon = create(:ingredient, name: "bourbon", ingredient_category: base_spirit)
      lime_wedge = create(:garnish, name: "lime wedge")
      hsh = {
        name: "Bad idea cocktail",
        notes: "some notes",
        technique: "shake",
        recipe_items_blob: "1 oz gin\n1/2 oz bourbon", # Not a real recipe! Don't try this at home. Or anywhere else. 🤢
        garnishes: [lime_wedge.name]
      }
      cocktail = Cocktail.import_from_hash(hsh)
      assert_equal hsh[:name], cocktail.name, "Should have the right name"
      assert_equal hsh[:notes], cocktail.notes, "Should have the right notes"
      assert_equal hsh[:technique], cocktail.technique, "Should have the right name"
      assert_equal hsh[:recipe_items_blob], cocktail.recipe_items_blob, "Should have the right recipe items"
      assert_same_elements [gin, bourbon], cocktail.ingredients, "Should have used the existing ingredient records"
      assert_same_elements [lime_wedge], cocktail.garnishes, "Should have the right garnishes"
    end
  end
end
