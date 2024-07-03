require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:recipe_items)
    should belong_to(:ingredient_category)
  end

  context "validations" do
    subject do
      build(:ingredient)
    end

    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)
  end

  context "an ingredient" do
    setup do
      @ingredient = create(:ingredient, ingredient_category: create(:ingredient_category))
    end

    should "be found by name" do
      assert_equal @ingredient, Ingredient.named(@ingredient.name).first
    end

    should "be found by uppercase name" do
      assert_equal @ingredient, Ingredient.named(@ingredient.name.upcase).first
    end

    should "be found by partial name" do
      assert_equal @ingredient, Ingredient.named(@ingredient.name[0..3]).first
    end

    context "equality" do
      should "be false for non-Ingredients" do
        refute @ingredient == @ingredient.name
      end

      should "be false if the names don't match" do
        refute @ingredient == Ingredient.new(name: 'Not the same name')
      end

      should "be true if the names match" do
        assert @ingredient == Ingredient.new(name: @ingredient.name)
      end
    end
  end

  context "import/export" do
    setup do
      @base_spirit = create(:ingredient_category, :base_spirit)
    end

    should "serialize to hash" do
      ingredient = build(:ingredient, ingredient_category: @base_spirit)
      expected = {
        name: ingredient.name,
        notes: ingredient.notes,
        ingredient_category: @base_spirit.name
      }
      assert_equal expected, ingredient.to_hash
    end

    should "import from hash" do
      hsh = {
        name: "allspice dram",
        notes: "so strong",
        ingredient_category: @base_spirit.name
      }
      ingredient = Ingredient.import_from_hash(hsh)
      assert_equal hsh[:name], ingredient.name, "Should have the right name"
      assert_equal hsh[:notes], ingredient.notes, "Should have the right notes"
      assert_equal @base_spirit, ingredient.ingredient_category, "Should have the right category"
    end
  end
end
