require 'test_helper'

class CocktailsControllerTest < ActionDispatch::IntegrationTest
  context "with an existing cocktail" do
    setup do
      @base_spirit = create(:ingredient_category, :base_spirit)
      @ingredient = create(:ingredient, ingredient_category: @base_spirit)
      @cocktail = create(:cocktail, recipe_items: [build(:recipe_item, ingredient: @ingredient)])
    end

    should "get index" do
      get cocktails_path
      assert_response :success
      assert_select ".cocktails cocktail", {count: Cocktail.count}, "Should have one card per cocktail"
    end

    should "show cocktail" do
      get cocktail_path(@cocktail)
      assert_response :success
    end
  end

  context "with multiple cocktails" do
    setup do
      @base_spirit = create(:ingredient_category, :base_spirit)
      @gin = create(:ingredient, name: "gin", ingredient_category: @base_spirit)
      @bourbon = create(:ingredient, name: "bourbon", ingredient_category: @base_spirit)

      @corpse_reviver = create(:cocktail,
        name: "Corpse Reviver #2",
        recipe_items: [build(:recipe_item, ingredient: @gin)]
      )

      @old_fashioned = create(:cocktail,
        name: "Old Fashioned",
        recipe_items: [build(:recipe_item, ingredient: @bourbon)]
      )
    end

    should "get index with an ingredient search" do
      get cocktails_path, params: {search_terms: {term_string: "gin"}}
      assert_response :success
      assert_select "cocktail##{dom_id(@corpse_reviver)}", {count: 1}, "Should have the corpse_reviver"

      get cocktails_path(search_terms: {term_string: "bourbon"})
      assert_response :success
      assert_select "cocktail##{dom_id(@old_fashioned)}", {count: 1}, "Should have the old_fashioned"
    end
  end
end
