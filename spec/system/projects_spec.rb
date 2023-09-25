require 'rails_helper'

RSpec.describe 'Projects', type: :system do
  include LoginSupport

  let(:user) { FactoryBot.create(:user) }
  let!(:project) do
    FactoryBot.create(:project,
                      name: 'RSpec tutorial',
                      owner: user)
  end

  scenario 'user creates a new project' do
    sign_in user
    go_to_home

    expect do
      click_link 'New Project'
      fill_in 'Name',	with: 'Test Project'
      fill_in 'Description',	with: 'Trying out Capybara'
      click_button 'Create Project'
    end.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content 'Project was successfully created'
      expect(page).to have_content 'Test Project'
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario 'user edit a project' do
    sign_in user
    go_to_home

    click_link 'RSpec tutorial'
    click_link 'Edit'
    fill_in 'Name', with: 'new project name'
    click_button 'Update Project'

    aggregate_failures do
      expect(page).to have_content 'Project was successfully updated.'
      expect(page).to have_content 'new project name'
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  def go_to_home
    visit root_path
  end
end
