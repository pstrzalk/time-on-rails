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

  test "should get duplicate prefilled from the source work without saving it" do
    @work.update!(description: "Code review", duration: 5400, started_at: nil)

    assert_no_difference("Work.count") do
      get duplicate_work_url(@work)
    end

    assert_response :success
    assert_select "form[action='#{works_path}'][method='post']"
    assert_select "#work_project_id option[selected][value='#{@work.project_id}']"
    assert_select "#work_description", text: "Code review"
    assert_select "#work_date[value='#{Date.current.iso8601}']"
    assert_select "#work_duration_hours[value='0']"
    assert_select "#work_duration_minutes[value='0']"
    assert_select "#work_duration_seconds[value='0']"
  end

  test "should not duplicate another user's work" do
    other_project = Project.create!(name: "Other", user: users(:two))
    other_work = Work.create!(project: other_project, user: users(:two), date: Date.current)

    get duplicate_work_url(other_work)
    assert_response :not_found
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
