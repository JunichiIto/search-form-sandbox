class ProjectsController < ApplicationController
  def index
    @project_search_form = ProjectSearchForm.new(project_search_form_params)
    @projects = @project_search_form.result.includes(:customer, :members).order(:id)
  end

  private

  def project_search_form_params
    params.fetch(:project_search_form, {}).permit(:keyword, :project, :customer, :member)
  end
end
