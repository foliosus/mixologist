require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:recipe_items).inverse_of(:unit)
  end

  context "validations" do
    subject do
      build(:unit)
    end

    should validate_length_of(:name).is_at_least(1).is_at_most(40)
    should validate_length_of(:abbreviation).is_at_least(1).is_at_most(4)
    should validate_numericality_of(:size_in_ounces).is_greater_than(0)
  end

  context "a saved unit" do
    setup do
      @unit = create(:unit)
    end

    should "be found by name" do
      assert_equal @unit, Unit.named(@unit.name).first
    end

    should "be found by uppercase name" do
      assert_equal @unit, Unit.named(@unit.name.upcase).first
    end

    should "be found by partial name" do
      assert_equal @unit, Unit.named(@unit.name[0..3]).first
    end

    should "be found by abbreviation" do
      assert_equal @unit, Unit.named(@unit.abbreviation).first
    end

    should "be found by uppercase abbreviation" do
      assert_equal @unit, Unit.named(@unit.abbreviation.upcase).first
    end
  end

  context "a unit with a different name and abbreviation" do
    setup do
      @unit = build(:unit, name: 'teaspoon', abbreviation: 'tsp')
    end

    should "use the abbreviation for 0.5 aliquots" do
      assert_equal @unit.abbreviation, @unit.abbreviation_for_amount(0.5)
    end

    should "use the abbreviation for 1 aliquot" do
      assert_equal @unit.abbreviation, @unit.abbreviation_for_amount(1)
    end

    should "use the abbreviation for 2 aliquots" do
      assert_equal @unit.abbreviation, @unit.abbreviation_for_amount(2)
    end
  end

  context "a unit with the same name and abbreviation" do
    setup do
      @unit = build(:unit, name: 'dash', abbreviation: 'dash')
    end

    should "use the plural name for 0.5 aliquots" do
      assert_equal @unit.name.pluralize, @unit.abbreviation_for_amount(0.5)
    end

    should "use the singular name for 1 aliquot" do
      assert_equal @unit.name, @unit.abbreviation_for_amount(1)
    end

    should "use the plural name for 2 aliquots" do
      assert_equal @unit.name.pluralize, @unit.abbreviation_for_amount(2)
    end
  end

  context "import/export" do
    should "serialize to hash" do
      unit = build(:unit)
      expected = {
        name: unit.name,
        abbreviation: unit.abbreviation,
        size_in_ounces: unit.size_in_ounces
      }
      assert_equal expected, unit.to_hash
    end

    should "import from hash" do
      hsh = {
        name: "dram",
        abbreviation: "dr",
        size_in_ounces: 1.0 / 16
      }
      unit = Unit.import_from_hash(hsh)
      assert_equal hsh[:name], unit.name, "Should have the right name"
      assert_equal hsh[:abbreviation], unit.abbreviation, "Should have the right abbreviation"
      assert_equal hsh[:size_in_ounces], unit.size_in_ounces, "Should have the right size in ounces"
    end
  end
end
