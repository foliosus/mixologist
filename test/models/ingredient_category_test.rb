require 'test_helper'

class IngredientCategoryTest < ActiveSupport::TestCase
  should have_many(:ingredients).inverse_of(:ingredient_category)
  should have_many(:cocktails).through(:ingredients)

  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)

  context "an ingredient category" do
    setup do
      @ingredient_category = create(:ingredient_category)
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

  context "import/export" do
    should "serialize to hash" do
      ingredient_category = build(:ingredient_category)
      expected = {
        name: ingredient_category.name
      }
      assert_equal expected, ingredient_category.to_hash
    end

    should "import from hash" do
      hsh = {
        name: "sauce",
      }
      ingredient_category = IngredientCategory.import_from_hash(hsh)
      assert_equal hsh[:name], ingredient_category.name, "Should have the right name"
    end
  end
end
