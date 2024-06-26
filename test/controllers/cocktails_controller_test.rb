require 'test_helper'

class CocktailsControllerTest < ActionDispatch::IntegrationTest
  context "with an existing cocktail" do
    setup do
      @cocktail = create(:cocktail)
    end
    teardown do
      @cocktail.destroy
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
      @gin = create(:ingredient, name: "gin")
      @bourbon = create(:ingredient, name: "bourbon")

      @corpse_reviver = create(:cocktail, name: "Corpse Reviver #2")
      create(:recipe_item, cocktail: @corpse_reviver, ingredient: @gin)

      @old_fashioned = create(:cocktail, name: "Old Fashioned")
      create(:recipe_item, cocktail: @old_fashioned, ingredient: @bourbon)
    end

    should "get index with an ingredient search" do
      get cocktails_path(search_terms: {term_string: "gin"})
      assert_response :success
      assert_select "cocktail##{dom_id(@corpse_reviver)}", {count: 1}, "Should have the corpse_reviver"

      get cocktails_path(search_terms: {term_string: "bourbon"})
      assert_response :success
      assert_select "cocktail##{dom_id(@old_fashioned)}", {count: 1}, "Should have the old_fashioned"
    end
  end
end
