class ProjectsController < ApplicationController
  def index
    @project_search_form = ProjectSearchForm.new(project_search_form_params)
    @projects = @project_search_form.result.order(:id)
  end

  private

  def project_search_form_params
    params.fetch(:project_search_form, {}).permit(:keyword, :project, :customer, :member, :member_count)
  end
end
