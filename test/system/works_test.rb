require "application_system_test_case"

class WorksTest < ApplicationSystemTestCase
  setup do
    @work = works(:one)
    sign_in users(:one)
  end

  test "visiting the index" do
    visit works_url
    assert_selector "h2", text: "Recent Work Sessions"
  end

  test "should create work" do
    visit works_url
    click_on "+ New work"

    find("#work_project_id option[value='#{@work.project_id}']").select_option
    click_on "Create Work Session"

    assert_text "Work was successfully created"
  end

  test "should update Work" do
    visit works_url
    click_on "Edit", match: :first

    find("#work_project_id option[value='#{@work.project_id}']").select_option
    click_on "Update Work Session"

    assert_text "Work was successfully updated"
  end

  test "should duplicate Work" do
    @work.update!(description: "Code review", duration: 5400, started_at: nil)

    visit works_url
    click_link "Duplicate", href: duplicate_work_path(@work)

    assert_field "work_description", with: "Code review"
    assert_field "work_date", with: Date.current.iso8601
    assert_equal @work.project_id.to_s, find("#work_project_id").value

    assert_difference("Work.count") do
      click_on "Create Work Session"
      assert_text "Work was successfully created"
    end

    duplicate = Work.order(:id).last
    assert_equal [ @work.project_id, "Code review", Date.current ], [ duplicate.project_id, duplicate.description, duplicate.date ]
    assert duplicate.in_progress?
  end

  test "should destroy Work" do
    visit works_url
    accept_confirm { click_on "Delete", match: :first }

    assert_text "Work was successfully destroyed"
  end
end
