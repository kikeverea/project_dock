require "test_helper"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work_unit = activities(:one)
  end

  test "should get index" do
    get activities_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_url
    assert_response :success
  end

  test "should create activity" do
    assert_difference("Activity.count") do
      post activities_url, params: { work_unit: {} }
    end

    assert_redirected_to activity_url(WorkUnit.last)
  end

  test "should show activity" do
    get activity_url(@work_unit)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_url(@work_unit)
    assert_response :success
  end

  test "should update activity" do
    patch activity_url(@work_unit), params: { work_unit: {} }
    assert_redirected_to activity_url(@work_unit)
  end

  test "should destroy activity" do
    assert_difference("Activity.count", -1) do
      delete activity_url(@work_unit)
    end

    assert_redirected_to activities_url
  end
end
