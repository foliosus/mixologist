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

    should validate_length_of(:name).is_at_least(1).is_at_most(40)
    should validate_uniqueness_of(:name)
  end

  context "an ingredient" do
    setup do
      @ingredient = create(:ingredient)
    end
    teardown do
      @ingredient.destroy
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

end
