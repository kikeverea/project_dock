require "application_system_test_case"

class CertificationTypesTest < ApplicationSystemTestCase
  setup do
    @certification_type = certification_types(:one)
  end

  test "visiting the index" do
    visit certification_types_url
    assert_selector "h1", text: "Certification types"
  end

  test "should create certification type" do
    visit certification_types_url
    click_on "New certification type"

    fill_in "Name", with: @certification_type.name
    click_on "Create Certification type"

    assert_text "Certification type was successfully created"
    click_on "Back"
  end

  test "should update Certification type" do
    visit certification_type_url(@certification_type)
    click_on "Edit this certification type", match: :first

    fill_in "Name", with: @certification_type.name
    click_on "Update Certification type"

    assert_text "Certification type was successfully updated"
    click_on "Back"
  end

  test "should destroy Certification type" do
    visit certification_type_url(@certification_type)
    click_on "Destroy this certification type", match: :first

    assert_text "Certification type was successfully destroyed"
  end
end
