class ProjectsController < ApplicationController
  layout :project_layout

  before_filter :require_admin, :only => [:edit, :update]
  before_filter :reset_current_url_to_root, :only => [:index, :show]

  def index
    @projects = Project.find_all_ongoing.reverse
    @past_projects = Project.find_all_expired.reverse
  end

  def show
    @project = Project.find params[:id]
    if @project.expired?
      redirect_to past_project_path(@project)
    end
    @projects = Project.find_ongoing.reverse
    @projects.delete(@project)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    @project.save && redirect_to(project_path(@project))
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html  { redirect_to(edit_project_path(@project),:notice => 'Project was successfully updated.') }
      end
    end
  end

  private
  def project_layout
    if params[:action] == "show" and [5,7,8,9,10,11,12,14,16,18].include?(params[:id].to_i)
      "project_#{params[:id]}"  
     # "project_special_12" if params[:id].to_i==12

    else
      (["index", "list", "new"].include? params[:action]) ? "index" : "project" 
    end
  end
end
