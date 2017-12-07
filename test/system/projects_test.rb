require 'application_system_test_case'


class ProjectsTest < ApplicationSystemTestCase
  test 'キーワード検索' do
    visit root_path
    assert_content '田中工業', count: 1
    assert_content '鈴木建設', count: 1

    fill_in 'キーワード', with: '田中'
    click_button '検索'
    assert_content '田中工業', count: 1
    assert_no_content '鈴木建設'

    check 'プロジェクト名'
    click_button '検索'
    assert_no_content '田中工業'
    assert_no_content '鈴木建設'

    uncheck 'プロジェクト名'
    check '顧客名'
    click_button '検索'
    assert_content '田中工業', count: 1
    assert_no_content '鈴木建設'

    check 'プロジェクト名'
    fill_in 'キーワード', with: 'プロジェクト'
    click_button '検索'
    assert_content '田中工業', count: 1
    assert_content '鈴木建設', count: 1

    fill_in 'キーワード', with: 'がんがん'
    click_button '検索'
    assert_no_content '田中工業'
    assert_content '鈴木建設', count: 1

    check 'メンバー名'
    uncheck 'プロジェクト名'
    uncheck '顧客名'
    fill_in 'キーワード', with: 'Alice'
    click_button '検索'
    assert_content '田中工業', count: 1
    assert_content '鈴木建設', count: 1

    fill_in 'キーワード', with: 'Bob'
    click_button '検索'
    assert_content '田中工業', count: 1
    assert_no_content '鈴木建設'
  end
end