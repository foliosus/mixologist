require 'test_helper'

class GarnishTest < ActiveSupport::TestCase
  should have_and_belong_to_many(:cocktails).inverse_of(:garnishes)
  should validate_presence_of(:name)

  context "import/export" do
    should "serialize to hash" do
      garnish = build(:garnish)
      expected = {
        name: garnish.name,
      }
      assert_equal expected, garnish.to_hash
    end

    should "import from hash" do
      hsh = {
        name: "glitter"
      }
      garnish = Garnish.import_from_hash(hsh)
      assert_equal hsh[:name], garnish.name, "Should have the right name"
    end
  end
end
