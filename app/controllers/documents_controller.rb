# == Schema Information
#
# Table name: documents
#
#  id                :integer          not null, primary key
#  project_id        :integer
#  sprint_id         :integer
#  release_id        :integer
#  user_story_id     :integer
#  file_id           :string           not null
#  file_filename     :string           not null
#  file_size         :string           not null
#  file_content_type :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class DocumentsController < ApplicationController
	# Once again note that, for models that are named differently, this method will have a different name (authenticate_admin! for Admin model).
	before_action :authenticate_user!
  before_action :set_document_and_project, only: [:edit, :update]

	def new
		@document = Document.new
		@project = Project.find(params[:project_id])

		if params[:attachment_type] == "all_project_documents"
    	@resource_id = ""
     else
      @resource_id = params[:resource_id]
    end
    @attachment_type = params[:attachment_type]
	end

	def create
		if request.post?
			document = Document.new(document_params)
	    document.save!
    	project = Project.find(params[:project_id])

	    case params[:attachment_type]
      when "specific_user_story_documents"
        user_story = UserStory.find(params[:resource_id])
        user_story.documents << document
      when "specific_release_documents"
      	release = Release.find(params[:resource_id])
        release.documents << document
      when "specific_sprint_documents"
      	sprint = Sprint.find(params[:resource_id])
        sprint.documents << document
      else
        project.documents << document
      end
	    
	    flash[:notice] = "Document created"
	    redirect_to :controller => "projects", :action => :documents, :id => project.id
  	end
	end

	def edit
	end

	def update
		if document.update(document_params)
      flash[:notice] = "Document #{document.file_filename} updated"
	    redirect_to :controller => "projects", :action => :documents, :id => @project.id
    else
      render :edit
    end
	end

	def destroy
		@document = Document.find(params[:id])
    flash[:notice] = "Document #{@document.file_filename} destroyed"
		@document.destroy
    # redirect_to :controller => "projects", :action => :documents, :id => @project.id
    redirect_back(fallback_location: projects_path)
	end

	private

		def set_document_and_project
      document = Document.find(params[:id])
			@project = Project.find(params[:project_id])
		end

		def document_params
			params.permit(:project_id)
			params.permit(:attachment_type)
			params.permit(:resource_id)
      # params.require(:document).permit(:file, :project_id, :attachment_type, :resource_id)
      params.require(:document).permit(:file)
    end
end
