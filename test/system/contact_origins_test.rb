require "application_system_test_case"

class ContactOriginsTest < ApplicationSystemTestCase
  setup do
    @contact_origin = contact_origins(:one)
  end

  test "visiting the index" do
    visit contact_origins_url
    assert_selector "h1", text: "Contact origins"
  end

  test "should create contact origin" do
    visit contact_origins_url
    click_on "New contact origin"

    fill_in "Name", with: @contact_origin.name
    click_on "Create Contact origin"

    assert_text "Contact origin was successfully created"
    click_on "Back"
  end

  test "should update Contact origin" do
    visit contact_origin_url(@contact_origin)
    click_on "Edit this contact origin", match: :first

    fill_in "Name", with: @contact_origin.name
    click_on "Update Contact origin"

    assert_text "Contact origin was successfully updated"
    click_on "Back"
  end

  test "should destroy Contact origin" do
    visit contact_origin_url(@contact_origin)
    click_on "Destroy this contact origin", match: :first

    assert_text "Contact origin was successfully destroyed"
  end
end
