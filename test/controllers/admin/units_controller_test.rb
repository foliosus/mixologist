require 'test_helper'

class Admin::UnitsControllerTest < ActionDispatch::IntegrationTest
  context "when not logged in" do
    should "not get the index" do
      get admin_units_path
      assert_response :not_found
    end
  end

  context "when logged in with a unit" do
    setup do
      @unit = create(:unit)
      @user = create(:user)
      login(@user, password: @user.password)
    end

    should "get index" do
      get admin_units_path
      assert_response :success
      assert_select "table tbody tr", {count: Unit.count}, "Should have one row per unit"
    end

    should "get new" do
      get new_admin_unit_path
      assert_response :success
    end

    should "create unit" do
      assert_difference('Unit.count', 1) do
        post admin_units_path, params: { unit: attributes_for(:unit) }
      end

      assert_redirected_to admin_units_path
    end

    should "get edit" do
      get edit_admin_unit_path(@unit)
      assert_response :success
    end

    should "update unit" do
      patch admin_unit_path(@unit), params: { unit: {name: 'new name'} }
      assert_redirected_to admin_units_path
      @unit.reload
      assert_equal 'new name', @unit.name
    end

    should "destroy unit" do
      assert_difference('Unit.count', -1) do
        delete admin_unit_path(@unit)
      end

      assert_redirected_to admin_units_path
    end
  end
end
