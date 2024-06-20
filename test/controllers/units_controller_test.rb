require 'test_helper'

class UnitsControllerTest < ActionController::TestCase
  context "with a unit" do
    setup do
      @unit = create :unit
    end
    teardown do
      @unit.destroy
    end

    should "get index" do
      get :index
      assert_response :success
      assert_select "table tbody tr", {count: 1}, "Should have one row per unit"
    end

    should "get new" do
      get :new
      assert_response :success
    end

    should "create unit" do
      assert_difference('Unit.count', 1) do
        post :create, params: { unit: attributes_for(:unit) }
      end

      assert_redirected_to units_path
    end

    should "get edit" do
      get :edit, params: { id: @unit.to_param }
      assert_response :success
    end

    should "update unit" do
      put :update, params: { id: @unit.to_param, unit: {name: 'new name'} }
      assert_redirected_to units_path
      @unit.reload
      assert_equal 'new name', @unit.name
    end

    should "destroy unit" do
      assert_difference('Unit.count', -1) do
        delete :destroy, params: { id: @unit.to_param }
      end

      assert_redirected_to units_path
    end
  end

  context "without a unit" do
    should "redirect to new from index" do
      Unit.delete_all
      get :index
      assert_redirected_to new_unit_path
    end
  end
end
