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
end
