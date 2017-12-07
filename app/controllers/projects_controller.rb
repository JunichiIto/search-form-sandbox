class ProjectsController < ApplicationController
  def index
    @project_search_form = ProjectSearchForm.new
    @project_search_form.set_defaults
    @projects = @project_search_form.result
  end
end
