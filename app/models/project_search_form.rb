class ProjectSearchForm
  include ActiveModel::Model

  KEYWORD_TARGETS = %w(project customer member).freeze
  MEMBER_COUNT_OPTIONS = {
      'none' => '指定無し',
      'one' => '1人',
      'two' => '2人',
      'three' => '3人',
  }.freeze

  attr_accessor :keyword, *KEYWORD_TARGETS, :member_count

  def result
    Project.all
  end

  def set_defaults
    self.member_count ||= 'none'
  end
end