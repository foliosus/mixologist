require 'test_helper'

class IngredientCategoryTest < ActiveSupport::TestCase
  should have_many(:ingredients)
  should have_many(:cocktails).through(:ingredients)

  should validate_length_of(:name).is_at_least(1).is_at_most(40)

  should validate_uniqueness_of(:name)

  context "an ingredient category" do
    setup do
      @ingredient_category = create(:ingredient_category)
    end
    teardown do
      @ingredient_category.destroy
    end

    should "be found by name" do
      assert_equal @ingredient_category, IngredientCategory.named(@ingredient_category.name).first
    end

    should "be found by uppercase name" do
      assert_equal @ingredient_category, IngredientCategory.named(@ingredient_category.name.upcase).first
    end

    should "be found by partial name" do
      assert_equal @ingredient_category, IngredientCategory.named(@ingredient_category.name[0..3]).first
    end

    context "equality" do
      should "be false for non-Ingredients" do
        refute @ingredient_category == @ingredient_category.name
      end

      should "be false if the names don't match" do
        refute @ingredient_category == IngredientCategory.new(name: 'Not the same name')
      end

      should "be true if the names match" do
        assert @ingredient_category == IngredientCategory.new(name: @ingredient_category.name)
      end
    end
  end

end
