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

  test "collapsing a day hides its entries and is remembered after reload" do
    Work.where(user: users(:one)).delete_all
    Work.create!(user: users(:one), project: projects(:one), date: Date.current, duration: 600, description: "Today's work")
    Work.create!(user: users(:one), project: projects(:one), date: Date.current - 3, duration: 1200, description: "Older work")

    visit works_url
    today = find("section", text: "Today")
    today.find("button[aria-expanded='true']").click

    assert_no_text "Today's work"
    assert_text "1 session • 10 minutes"
    assert_text "Older work"

    visit works_url
    assert_selector "section button[aria-expanded='false']", text: "Today"
    assert_no_text "Today's work"
    assert_text "Older work"

    find("section button", text: "Today").click
    assert_text "Today's work"

    visit works_url
    assert_text "Today's work"
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

  test "should destroy Work" do
    visit works_url
    accept_confirm { click_on "Delete", match: :first }

    assert_text "Work was successfully destroyed"
  end
end
