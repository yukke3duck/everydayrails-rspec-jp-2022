require 'rails_helper'

RSpec.describe Note, type: :model do
  # ファクトリで関連するデータを生成する
  it 'generates asssociated data from a factory' do
    note = FactoryBot.create(:note)
    puts "This note's project is #{note.project.inspect}"
    puts "This note'use is #{note.user.inspect}"
  end

  # ユーザー、プロジェクト、メッセージがあれば、有効な状態であること
  it 'is valid with a user, project, and message' do
    note = FactoryBot.build(:note)
    expect(note).to be_valid
  end

  # メッセージがなければ無効な状態であること
  it 'is invalid without a message' do
    note = FactoryBot.build(:note, message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  # 文字列に一致するメッセージを検索する
  describe 'search message for a term' do
    before do
      @note1 = FactoryBot.create(:note, message: 'This is the first note.')
      @note2 = FactoryBot.create(:note, message: 'This is the second note.')
      @note3 = FactoryBot.create(:note, message: 'First, preheat the oven.')
    end
    # 一致するデータが見つかるとき
    context 'when a match is found' do
      # 検索文字列に一致するメモを返すこと
      it 'returns notes that match the search term' do
        expect(Note.search('first')).to include(@note1, @note3)
        expect(Note.search('first')).to_not include(@note2)
      end
    end

    # 一致するデータが1件も見つからないとき
    context 'when no match is found' do
      # 空のコレクションを返すこと
      it 'returns an empty collection' do
        expect(Note.search('message')).to be_empty
      end
    end
  end
end
