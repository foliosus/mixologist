require 'test_helper'

class RecipeItemTest < ActiveSupport::TestCase
  should belong_to(:cocktail)
  should belong_to(:ingredient)
  should belong_to(:unit)

  should "have a summary" do
    ri = build(:recipe_item, amount: 1)
    assert_equal "1 #{ri.unit.abbreviation} #{ri.ingredient.name}", ri.summary
  end

  should "have a summary with a complex fraction" do
    ri = build(:recipe_item, amount: 1.5)
    assert_equal "1 1/2 #{ri.unit.abbreviation} #{ri.ingredient.name}", ri.summary
  end

  should "have a summary with a fraction less than 1" do
    ri = build(:recipe_item, amount: 0.5)
    assert_equal "1/2 #{ri.unit.abbreviation} #{ri.ingredient.name}", ri.summary
  end

  should "have no summary without an ingredient" do
    ri = build(:recipe_item)
    ri.ingredient = nil
    assert ri.summary.blank?
  end

  # The total volume is used when sorting, so let's ensure there's a value
  should "have a total volume of zero without an amount" do
    ri = build(:recipe_item, amount: nil)
    assert_nil ri.amount
    assert_equal 0, ri.total_volume
  end

  should "blank out an existing summary" do
    ri = build(:recipe_item)
    tested_attributes = [:unit, :ingredient, :amount]
    tested_attributes.each do |attrib|
      assert ri.send(attrib).present?, "Should have a value for #{attrib}"
    end
    assert ri.summary.present?, "Should have a summary"

    ri.summary = nil
    tested_attributes.each do |attrib|
      assert ri.send(attrib).nil?, "Should have nil for #{attrib}"
    end
    assert ri.summary.blank?, "Should have an empty summary"
  end

  should "have a summary without a unit" do
    ri = build(:recipe_item, unit: nil)
    rational = Rational(ri.amount)
    expected = rational.denominator == 1 ? rational.numerator.to_s : rational.to_s
    assert_equal "#{expected} #{ri.ingredient.name}", ri.summary
  end

  should "not have a summary without an ingredient" do
    ri = build(:recipe_item, ingredient: nil)
    assert ri.summary.blank?
  end

  context "with an ingredient and a unit" do
    setup do
      Unit.delete_all
      Ingredient.delete_all
      @unit = create(:unit, name: 'ounce', abbreviation: 'oz')
      @ingredient = create(:ingredient, name: 'brandy')
    end
    teardown do
      @unit.destroy
      @ingredient.destroy
    end

    should "accept a new summary" do
      ri = build(:recipe_item)
      assert @unit != ri.unit, "New and old units should be different"
      assert @ingredient != ri.ingredient, "New and old ingredients should be different"
      ri.summary = "7 #{@unit.name} #{@ingredient.name}"
      assert_equal 7, ri.amount
      assert_equal @unit, ri.unit
      assert_equal @ingredient, ri.ingredient
    end

    should "have a total_volume" do
      item = RecipeItem.new(amount: 2, unit: @unit, ingredient: @ingredient)
      assert_equal item.amount * @unit.size_in_ounces, item.total_volume, "Should use the amount times the size of the measure to calculate the total volume"
    end

    context "sorting" do
      should "be by total volume" do
        item1 = RecipeItem.new(unit: @unit, ingredient: @ingredient, amount: 1)
        item2 = RecipeItem.new(unit: @unit, ingredient: @ingredient, amount: 2)
        items = [item1, item2]

        assert_equal [item2, item1], items.sort, "Should sort from largest to smallest volume"
      end

      should "use the ingredient name when the volumes are equal" do
        item1 = RecipeItem.new(unit: @unit, ingredient: Ingredient.new(name: 'foo'), amount: 1)
        item2 = RecipeItem.new(unit: @unit, ingredient: Ingredient.new(name: 'bar'), amount: 1)
        items = [item1, item2]

        assert_equal [item2, item1], items.sort, "Should sort alphabetically by name"
      end
    end
  end

  should "create a new ingredient when parsing from string" do
    ri = RecipeItem.parse_from_string('1 oz apple cider')
    assert ri.is_a?(RecipeItem), "Should be a RecipeItem, not #{ri.class}"
    assert ri.ingredient.present?, "Should have one ingredient"
  end
end
