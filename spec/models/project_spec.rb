require 'rails_helper'

RSpec.describe Project, type: :model do
  # 名前があれば有効な状態であること
  # it 'is valid with a name' do
  #   expect(FactoryBot.build(:project)).to be_valid
  # end

  # 名前がなければ無効な状態であること
  # it 'is invalid without a name' do
  #   project = FactoryBot.build(:project, name: nil)
  #   project.valid?
  #   expect(project.errors[:name]).to include("can't be blank")
  # end
  it { is_expected.to validate_presence_of(:name) }

  it 'can have many notes' do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  # 同じ名前のプロジェクトを作成する
  # describe 'create projects as duplicate name' do
  # before do
  #   @project = FactoryBot.create(:project)
  # end

  # # ユーザー単位では重複したプロジェクト名を許可しないこと
  # it 'doen not allow duplicate project names per user' do
  #   new_project = FactoryBot.build(:project,
  #                                  owner: @project.owner,
  #                                  name: @project.name)
  #   new_project.valid?
  #   expect(new_project.errors[:name]).to include('has already been taken')
  # end

  # # 二人のユーザーが同じ名前を使うことは許可すること
  # it 'allows two users to share a project name' do
  #   other_project = FactoryBot.build(:project,
  #                                    name: @project.name)
  #   expect(other_project).to be_valid
  # end
  # end
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  describe 'late status' do
    it 'is late when the due date is past today' do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it 'is on time when the due date is today' do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    it 'is on time when the due date is the future' do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
