require 'test_helper'

class CocktailTest < ActiveSupport::TestCase
  should have_many(:recipe_items)
  should have_many(:ingredients).through(:recipe_items)
  should have_and_belong_to_many(:garnishes)

  context "with a blob description" do
    setup do
      @unit = create(:unit, abbreviation: 'oz')
      @recipe_item_strings = ["1 oz brandy", "1 oz lemon juice"]
      @blob = @recipe_item_strings.join("\r\n")
    end
    teardown do
      @unit.destroy
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
      should "be the techinque with the garnishes" do
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
end
