require 'test_helper'

class Admin::CocktailsControllerTest < ActionDispatch::IntegrationTest
  context "when not logged in" do
    should "not get the index" do
      get admin_cocktails_path
      assert_response :not_found
    end
  end

  context "when logged in with a cocktail" do
    setup do
      @base_spirit = create(:ingredient_category, :base_spirit)
      @bourbon = create(:ingredient, name: "bourbon", ingredient_category: @base_spirit)
      @cocktail = create(:cocktail, recipe_items: [build(:recipe_item, ingredient: @bourbon)])
      @user = create(:user)
      login(@user, password: @user.password)
    end

    should "get index" do
      get admin_cocktails_path
      assert_response :success
      assert_select ".cocktails cocktail", {count: Cocktail.count}, "Should have one card per cocktail"
    end

    should "show cocktail" do
      get admin_cocktail_path(@cocktail)
      assert_response :success
    end

    should "get new" do
      get new_admin_cocktail_path
      assert_response :success
    end

    should "create cocktail" do
      create(:unit, :ounce)
      create(:ingredient, name: "sweet vermouth")
      create(:ingredient, name: "dry vermouth")
      cocktail_attributes = {
        name: "New cocktail name",
        recipe_items_blob: "2 oz bourbon\n1/4 oz sweet vermouth\n1/4 oz dry vermouth",
        technique: "shake"
      }
      assert_difference('Cocktail.count') do
        post admin_cocktails_path, params: { cocktail: cocktail_attributes }
      end

      assert_redirected_to admin_cocktail_path(Cocktail.last)
    end

    should "get edit" do
      get edit_admin_cocktail_path(@cocktail)
      assert_response :success
    end

    should "update cocktail" do
      patch admin_cocktail_path(@cocktail), params: { cocktail: {name: "new name"} }
      assert_redirected_to admin_cocktail_path(@cocktail)
      @cocktail.reload
      assert_equal "new name", @cocktail.name
    end

    should "destroy cocktail" do
      assert_difference('Cocktail.count', -1) do
        delete admin_cocktail_path(@cocktail)
      end

      assert_redirected_to admin_cocktails_path
    end
  end
end
