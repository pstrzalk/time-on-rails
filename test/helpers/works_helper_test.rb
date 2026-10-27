require "test_helper"

class WorksHelperTest < ActionView::TestCase
  test "work_day_label names today and yesterday" do
    travel_to Time.zone.local(2026, 8, 5, 12) do
      assert_equal "Today", work_day_label(Date.new(2026, 8, 5))
      assert_equal "Yesterday", work_day_label(Date.new(2026, 8, 4))
    end
  end

  test "work_day_label shows the full date for older days" do
    travel_to Time.zone.local(2026, 8, 5, 12) do
      assert_equal "Monday, 03-08-2026", work_day_label(Date.new(2026, 8, 3))
    end
  end

  test "work_day_summary shows the session count and total time" do
    assert_equal "1 session • 45 minutes", work_day_summary(sessions_count: 1, total_time: 45 * 60)
    assert_equal "3 sessions • 2 hours 5 minutes", work_day_summary(sessions_count: 3, total_time: 2 * 3600 + 5 * 60)
  end

  test "work_day_summary shows zero time explicitly" do
    assert_equal "1 session • 0 seconds", work_day_summary(sessions_count: 1, total_time: 0)
  end
end
