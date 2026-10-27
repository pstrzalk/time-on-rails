require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    @project = projects(:one)
    sign_in users(:one)
  end

  test "visiting the index" do
    visit projects_url
    assert_selector "h2", text: "Projects"
  end

  test "should create project" do
    visit projects_url
    click_on "+ New Project"

    fill_in "Name", with: @project.name
    click_on "Create Project"

    assert_text "Project was successfully created"
  end

  test "should update Project" do
    visit projects_url
    click_on "Edit", match: :first

    fill_in "Name", with: @project.name
    click_on "Update Project"

    assert_text "Project was successfully updated"
  end

  test "should destroy Project" do
    visit projects_url
    accept_confirm { click_on "Delete", match: :first }

    assert_text "Project was successfully destroyed"
  end
end
