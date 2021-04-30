require 'rails_helper'
require_relative '../support/controller_macros.rb'

def log_in
  visit new_project_path
  click_link 'Sign up'
  within("form") do
    fill_in "Email", with: "testing@test.com"
    fill_in "Password", with: "123456"
    fill_in "Password confirmation", with: "123456"
    click_button "Sign up"
  end
  click_link "Sign Out"
  visit new_project_path
  within("form") do
    fill_in "Email", with: "testing@test.com"
    fill_in "Password", with: "123456"
    click_button "Log in"
  end
end

RSpec.feature "Projects", type: :feature do
  context "Login" do
    scenario "should sign up" do
      visit new_project_path
      click_link 'Sign up'
      within("form") do
        fill_in "Email", with: "testing@test.com"
        fill_in "Password", with: "123456"
        fill_in "Password confirmation", with: "123456"
        click_button "Sign up"
      end
      expect(page).to have_content("Welcome! You have signed up successfully.")
    end


    scenario "should log in" do
      log_in
      expect(page).to have_content("Signed in successfully.")
    end
  end

  context "Create new project" do
    before(:each) do
      visit new_project_path
      log_in
      within("form") do
        fill_in "Title", with: "Test title"
      end
    end

    scenario "should be successful" do
      fill_in "Description", with: "Test description"
      click_button "Create Project"
      expect(page).to have_content("Project was successfully created")
    end

    scenario "should fail" do
      click_button "Create Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Update project" do
    let(:project) { Project.create(title: "Test title", description: "Test content") }
    before(:each) do
      log_in
      visit edit_project_path(project)
    end

    scenario "should be successful" do
      within("form") do
        fill_in "Description", with: "New description content"
      end
      click_button "Update Project"
      expect(page).to have_content("Project was successfully updated")
    end

    scenario "should fail" do
      within("form") do
        fill_in "Description", with: ""
      end
      click_button "Update Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Remove existing project" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }
    scenario "remove project" do
      log_in
      visit projects_path
      click_link "Destroy"
      expect(page).to have_content("Project was successfully destroyed")
      expect(Project.count).to eq(0)
    end
  end
end