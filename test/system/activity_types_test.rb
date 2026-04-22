require "application_system_test_case"

class ActivityTypesTest < ApplicationSystemTestCase
  setup do
    @service_invoice = services(:one)
  end

  test "visiting the index" do
    visit services_url
    assert_selector "h1", text: "Activity types"
  end

  test "should create activity type" do
    visit services_url
    click_on "New activity type"

    fill_in "Name", with: @service_invoice.name
    click_on "Create Activity type"

    assert_text "Activity type was successfully created"
    click_on "Back"
  end

  test "should update Activity type" do
    visit service_url(@service_invoice)
    click_on "Edit this activity type", match: :first

    fill_in "Name", with: @service_invoice.name
    click_on "Update Activity type"

    assert_text "Activity type was successfully updated"
    click_on "Back"
  end

  test "should destroy Activity type" do
    visit service_url(@service_invoice)
    click_on "Destroy this activity type", match: :first

    assert_text "Activity type was successfully destroyed"
  end
end
