require 'test_helper'

class RecipeItem::ParserTest < ActiveSupport::TestCase
  setup do
    Unit.delete_all
    Ingredient.delete_all
    @unit = create(:unit, name: 'ounce', abbreviation: 'oz')
    @ingredient = create(:ingredient, name: 'brandy', ingredient_category: create(:ingredient_category))
  end

  {'1/4' => 0.25, '0.25' => 0.25, '.25' => 0.25, '1' => 1, '1 1/2' => 1.5}.each do |amount_str, amount|
    ['ounce', 'ounces', 'oz'].each do |unit|
      ['brandy', 'Brandy'].each do |ingredient|
        [ "#{amount_str} #{unit} #{ingredient}",
          "#{amount_str} #{unit} of #{ingredient}"
        ].each do |str|
          should "parse #{str}" do
            ri = RecipeItem::Parser.new(str).parse!
            assert_equal amount, ri.amount
            assert_equal @unit, ri.unit
            assert_equal @ingredient, ri.ingredient
          end
        end
      end
    end
  end

  should "parse brandy" do
    ri = RecipeItem::Parser.new("#{@ingredient.name}").parse!
    assert_nil ri.amount
    assert_nil ri.unit
    assert_equal @ingredient, ri.ingredient
  end

  should "parse 1 egg" do
    egg = create(:ingredient, name: "egg", ingredient_category: create(:ingredient_category))
    ri = RecipeItem::Parser.new("1 egg").parse!
    assert_equal 1, ri.amount
    assert_nil ri.unit
    assert_equal egg, ri.ingredient
  end
end