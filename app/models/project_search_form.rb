class ProjectSearchForm
  include ActiveModel::Model

  KEYWORD_TARGETS = %w(project customer member).freeze

  attr_accessor :keyword, *KEYWORD_TARGETS

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
        conditions << <<~SQL
          EXISTS(
            SELECT *
            FROM memberships ms
            INNER JOIN members m
              ON m.id = ms.member_id
            WHERE
                ms.project_id = projects.id
            AND m.name ILIKE :keyword
          )
        SQL
      end
      sql = "(#{conditions.join(" OR ")})"
      scope = scope.where(sql, keyword: "%#{keyword}%")
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