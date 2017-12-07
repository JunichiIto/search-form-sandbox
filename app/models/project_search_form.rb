class ProjectSearchForm
  include ActiveModel::Model

  KEYWORD_TARGETS = %w(project customer member).freeze
  MEMBER_COUNT_OPTIONS = {
      '' => '指定無し',
      '1' => '1人',
      '2' => '2人',
      '3' => '3人',
  }.freeze

  attr_accessor :keyword, *KEYWORD_TARGETS, :member_count

  def result
    scope = Project.all

    if keyword.present?
      conditions = []
      if target_none? || project_selected?
        conditions << "projects.name ILIKE :keyword"
      end
      if target_none? || customer_selected?
        scope = scope.joins(:customer)
        conditions << "customers.name ILIKE :keyword"
      end
      if target_none? || member_selected?
        condition = <<~SQL
          EXISTS(
            SELECT *
            FROM
              memberships ms
              INNER JOIN members m
                ON m.id = ms.member_id
            WHERE
              ms.project_id = projects.id
            AND m.name ILIKE :keyword)
        SQL
        conditions << condition
      end
      condition = "(#{conditions.join(" OR ")})"
      scope = scope.where(condition, keyword: "%#{keyword}%")
    end

    if member_count.present?
      count = member_count.to_i
      join_sql = <<~SQL
        INNER JOIN (
          SELECT
            p.id AS project_id,
            COUNT(*) AS member_count
          FROM projects p 
          INNER JOIN memberships m
            ON m.project_id = p.id
          GROUP BY
            p.id
        ) AS member_counts
        ON member_counts.project_id = projects.id
      SQL
      scope = scope.joins(join_sql).where("member_counts.member_count = ?", count)
    end

    scope
  end

  private

  def target_none?
    !(project_selected? || customer_selected? || member_selected?)
  end

  def project_selected?
    selected?('project')
  end

  def customer_selected?
    selected?('customer')
  end

  def member_selected?
    selected?('member')
  end

  def selected?(field)
    send(field) == '1'
  end
end