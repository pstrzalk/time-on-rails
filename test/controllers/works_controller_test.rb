require "test_helper"

class WorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work = works(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get works_url
    assert_response :success
  end

  test "index groups works under day headers, newest day first" do
    Work.where(user: users(:one)).delete_all
    project = projects(:one)
    travel_to Time.zone.local(2026, 8, 5, 12) do
      Work.create!(user: users(:one), project: project, date: Date.new(2026, 8, 5), duration: 30 * 60, description: "Today A")
      Work.create!(user: users(:one), project: project, date: Date.new(2026, 8, 5), duration: 15 * 60, description: "Today B")
      Work.create!(user: users(:one), project: project, date: Date.new(2026, 8, 4), duration: 3600, description: "Yesterday")
      # Created last but dated earliest: must still be listed under its own day, at the bottom
      Work.create!(user: users(:one), project: project, date: Date.new(2026, 8, 3), duration: 600, description: "Backfilled")

      get works_url
    end

    assert_response :success
    assert_select "section[data-controller='day-group']", 3
    headers = css_select("section[data-controller='day-group'] h3").map { |h| h.text.squish }
    assert_equal [
      "Today 2 sessions • 45 minutes",
      "Yesterday 1 session • 1 hours",
      "Monday, 03-08-2026 1 session • 10 minutes"
    ], headers
    descriptions = css_select("section h4").map { |h| h.text.squish }
    assert_equal [ "Today B", "Today A", "Yesterday", "Backfilled" ], descriptions
  end

  test "index day totals include entries of the same day on another page" do
    Work.where(user: users(:one)).delete_all
    21.times do
      Work.create!(user: users(:one), project: projects(:one), date: Date.new(2026, 8, 3), duration: 60)
    end

    get works_url
    assert_select "section[data-controller='day-group'] div.bg-gray-900", 20
    assert_select "section h3", text: /21 sessions • 21 minutes/

    get works_url(page: 2)
    assert_select "section[data-controller='day-group'] div.bg-gray-900", 1
    assert_select "section h3", text: /21 sessions • 21 minutes/
  end

  test "index day totals respect the project filter" do
    Work.where(user: users(:one)).delete_all
    Work.create!(user: users(:one), project: projects(:one), date: Date.new(2026, 8, 3), duration: 600)
    Work.create!(user: users(:one), project: projects(:two), date: Date.new(2026, 8, 3), duration: 1200)

    get works_url(project_id: projects(:one).id)
    assert_select "section h3", text: /1 session • 10 minutes/
  end

  test "should get new" do
    get new_work_url
    assert_response :success
  end

  test "should create work" do
    assert_difference("Work.count") do
      post works_url, params: { work: { project_id: @work.project_id, date: @work.date } }
    end

    assert_redirected_to works_url
  end

  test "should show work" do
    get work_url(@work, format: :json)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_url(@work)
    assert_response :success
  end

  test "should update work" do
    patch work_url(@work), params: { work: { project_id: @work.project_id, date: @work.date } }
    assert_redirected_to works_url
  end

  test "should destroy work" do
    assert_difference("Work.count", -1) do
      delete work_url(@work)
    end

    assert_redirected_to works_url
  end
end
