require 'test_helper'

class Admin::IngredientsControllerTest < ActionDispatch::IntegrationTest
  context "when not logged in" do
    should "not get the index" do
      get admin_ingredients_path
      assert_response :not_found
    end
  end

  context "when logged in with an ingredient" do
    setup do
      @ingredient = create(:ingredient)
      @user = create(:user)
      login(@user, password: @user.password)
    end

    teardown do
      @user.destroy
      @ingredient.destroy
    end

    should "get index" do
      get admin_ingredients_path
      assert_response :success
      assert_select "table tbody tr", {count: Ingredient.count}, "Should have one row per ingredient"
    end

    should "get new" do
      get new_admin_ingredient_path
      assert_response :success
    end

    should "create ingredient" do
      attribs = attributes_for(:ingredient)
      attribs[:ingredient_category_id] = attribs.delete(:ingredient_category).id
      assert_difference('Ingredient.count') do
        post admin_ingredients_path, params: { ingredient: attribs }
      end

      assert_redirected_to admin_ingredients_path
    end

    should "get edit" do
      get edit_admin_ingredient_path(@ingredient)
      assert_response :success
    end

    should "update ingredient" do
      patch admin_ingredient_path(@ingredient), params: { ingredient: {name: 'new name'} }
      assert_redirected_to admin_ingredients_path
      @ingredient.reload
      assert_equal 'new name', @ingredient.name
    end

    should "destroy ingredient" do
      assert_difference('Ingredient.count', -1) do
        delete admin_ingredient_path(@ingredient)
      end

      assert_redirected_to admin_ingredients_path
    end
  end
end
