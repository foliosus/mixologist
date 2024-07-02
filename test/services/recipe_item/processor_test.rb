require 'test_helper'

class RecipeItem::ProcessorTest < ActiveSupport::TestCase
  context "with a cocktail with two items" do
    setup do
      @ingredient_category = create(:ingredient_category)
      @ingredient1 = create(:ingredient, ingredient_category: @ingredient_category)
      @ingredient2 = create(:ingredient, ingredient_category: @ingredient_category)
      @unit1 = create(:unit)
      @unit2 = create(:unit)
      @cocktail = build(:cocktail, recipe_items: [
          RecipeItem.new(ingredient: @ingredient1, unit: @unit1, amount: 1),
          RecipeItem.new(ingredient: @ingredient2, unit: @unit2, amount: 2),
      ])
      @item_summary1 = @cocktail.recipe_items.first.summary
      @item_summary2 = @cocktail.recipe_items.second.summary
    end

    should "delete an ingredient if it's missing from the update" do
      new_items = RecipeItem::Processor.process(@cocktail, [@item_summary2])

      assert_equal 1, new_items.length, "Should have only one item in the list"

      assert_equal new_items.first.__id__, @cocktail.recipe_items.second.__id__, "Should have the same object identity for the unmodified item"
    end

    should "add an ingredient if it's in the update" do
      new_ingredient = create(:ingredient)
      expected_new_item = RecipeItem.new(ingredient: new_ingredient, unit: @unit1, amount: 1)
      new_items = RecipeItem::Processor.process(@cocktail, [@item_summary1, @item_summary2, expected_new_item.summary])

      assert_equal 3, new_items.length, "Should have a new item in the list"

      2.times do |n|
        assert_equal new_items[n].__id__, @cocktail.recipe_items[n].__id__, "Sholud have the same object identity for unmodified item"
      end

      assert_equal expected_new_item.summary, new_items[2].summary
    end

    should "modify an existing ingredient if it's in the update" do
      modified_summary2 = @item_summary2.sub("2", "3")
      new_items = RecipeItem::Processor.process(@cocktail, [@item_summary1, modified_summary2])

      assert_equal 2, new_items.length, "Should have the same number of ingredients in the list"

      assert_equal new_items.first.__id__, @cocktail.recipe_items.first.__id__, "Should have same object identity for unmodified item"
      assert_equal new_items.second.__id__, @cocktail.recipe_items.second.__id__, "Should have same object identity for modified item"

      assert_equal @item_summary1, new_items.first.summary, "Should have same summary for unmodified item"
      assert_equal modified_summary2, new_items.second.summary, "Should have new summary for modified item"
    end
  end
end