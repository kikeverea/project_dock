require "application_system_test_case"

class MaintenanceCancellationsTest < ApplicationSystemTestCase
  setup do
    @maintenance_cancellation_reason = maintenance_cancellations(:one)
  end

  test "visiting the index" do
    visit maintenance_cancellations_url
    assert_selector "h1", text: "Maintenance cancellations"
  end

  test "should create maintenance cancellation" do
    visit maintenance_cancellations_url
    click_on "New maintenance cancellation"

    fill_in "Name", with: @maintenance_cancellation_reason.name
    click_on "Create Maintenance cancellation"

    assert_text "Maintenance cancellation was successfully created"
    click_on "Back"
  end

  test "should update Maintenance cancellation" do
    visit maintenance_cancellation_url(@maintenance_cancellation_reason)
    click_on "Edit this maintenance cancellation", match: :first

    fill_in "Name", with: @maintenance_cancellation_reason.name
    click_on "Update Maintenance cancellation"

    assert_text "Maintenance cancellation was successfully updated"
    click_on "Back"
  end

  test "should destroy Maintenance cancellation" do
    visit maintenance_cancellation_url(@maintenance_cancellation_reason)
    click_on "Destroy this maintenance cancellation", match: :first

    assert_text "Maintenance cancellation was successfully destroyed"
  end
end
