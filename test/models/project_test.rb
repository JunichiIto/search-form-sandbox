require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'relationships' do
    assert_equal 2, Project.count
    tanaka_project = projects(:tanaka_project)
    assert_equal '田中工業', tanaka_project.customer.name
    assert_equal ['Alice', 'Bob'], tanaka_project.members.map(&:name).sort
    suzuki_project = projects(:suzuki_project)
    assert_equal '鈴木建設', suzuki_project.customer.name
    assert_equal ['Alice', 'Carol', 'Dave'], suzuki_project.members.map(&:name).sort
  end
end
