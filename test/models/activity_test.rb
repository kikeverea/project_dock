require "test_helper"

class ActivityTest < ActiveSupport::TestCase

  test "Generates number" do
    activity = Fabricate :activity

    assert_equal "OF#{Time.current.year.to_s.last(2)}.001", activity.number
  end

  test "Generates number for corresponding year" do
    activity = Fabricate(:activity, created_at: 1.year.ago)

    assert_equal "OF#{1.year.ago.year.to_s.last(2)}.001", activity.number
  end

  test "Generates number with custom numeration" do
    activity = Fabricate(:activity, number_part: "001B")

    assert_equal "OF#{Time.current.year.to_s.last(2)}.001B", activity.number
  end

  test "Editing a number keeps the number sequence" do
    activity_1 = Fabricate(:activity)
    activity_2 = Fabricate(:activity)

    activity_1.update!(number: "OF26.002")
    activity_2.update!(number: "OF26.001")

    new_activity = Fabricate :activity

    assert_equal "OF#{Time.current.year.to_s.last(2)}.003", new_activity.number
  end
end
