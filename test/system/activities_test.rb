require "application_system_test_case"

class ActivitiesTest < ApplicationSystemTestCase
  setup do
    @work_unit = activities(:one)
  end

  test "visiting the index" do
    visit activities_url
    assert_selector "h1", text: "Activities"
  end

  test "should create activity" do
    visit activities_url
    click_on "New activity"

    fill_in "Activity type", with: @work_unit.service
    fill_in "Contact", with: @work_unit.client_id
    click_on "Create Activity"

    assert_text "Activity was successfully created"
    click_on "Back"
  end

  test "should update Activity" do
    visit activity_url(@work_unit)
    click_on "Edit this activity", match: :first

    fill_in "Activity type", with: @work_unit.service
    fill_in "Contact", with: @work_unit.client_id
    click_on "Update Activity"

    assert_text "Activity was successfully updated"
    click_on "Back"
  end

  test "should destroy Activity" do
    visit activity_url(@work_unit)
    click_on "Destroy this activity", match: :first

    assert_text "Activity was successfully destroyed"
  end
end
