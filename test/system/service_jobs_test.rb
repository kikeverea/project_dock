require "application_system_test_case"

class ServiceJobsTest < ApplicationSystemTestCase
  setup do
    @service_job = service_jobs(:one)
  end

  test "visiting the index" do
    visit service_jobs_url
    assert_selector "h1", text: "Service jobs"
  end

  test "should create service job" do
    visit service_jobs_url
    click_on "New service job"

    fill_in "Day price", with: @service_job.day_price
    fill_in "Days", with: @service_job.days
    fill_in "Observations", with: @service_job.observations
    fill_in "Service date", with: @service_job.service_date
    fill_in "Service", with: @service_job.service_id
    fill_in "Technician", with: @service_job.technician_id
    click_on "Create Service job"

    assert_text "Service job was successfully created"
    click_on "Back"
  end

  test "should update Service job" do
    visit service_job_url(@service_job)
    click_on "Edit this service job", match: :first

    fill_in "Day price", with: @service_job.day_price
    fill_in "Days", with: @service_job.days
    fill_in "Observations", with: @service_job.observations
    fill_in "Service date", with: @service_job.service_date
    fill_in "Service", with: @service_job.service_id
    fill_in "Technician", with: @service_job.technician_id
    click_on "Update Service job"

    assert_text "Service job was successfully updated"
    click_on "Back"
  end

  test "should destroy Service job" do
    visit service_job_url(@service_job)
    click_on "Destroy this service job", match: :first

    assert_text "Service job was successfully destroyed"
  end
end
