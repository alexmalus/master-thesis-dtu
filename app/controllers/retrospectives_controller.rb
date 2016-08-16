# == Schema Information
#
# Table name: retrospectives
#
#  id                 :integer          not null, primary key
#  name               :string
#  description_good   :string
#  description_bad    :string
#  description_future :string
#  sprint_id          :integer
#  project_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class RetrospectivesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_retrospective, only: [:show, :edit, :update, :destroy]

  # GET /retrospectives
  # GET /retrospectives.json
  def index
    @retrospectives = Retrospective.all
  end

  # GET /retrospectives/1
  # GET /retrospectives/1.json
  def show
  end

  # GET /retrospectives/new
  def new
    @retrospective = Retrospective.new
  end

  # GET /retrospectives/1/edit
  def edit
  end

  # POST /retrospectives
  def create
    if request.post?
      begin
      @retrospective = Retrospective.new(retrospective_params)
      @retrospective.save!
      
      @project = @retrospective.project
      @sprint = @retrospective.sprint
      @sprint.done
      @sprint.save!
      
      @project.retrospectives << @retrospective
      flash[:notice] = "Retrospective created"

      rescue Exception => e
        flash[:alert] = "Cannot create retrospective. Reason: #{e}. Please try again"
      end
      redirect_to :controller => :projects, :action => :retrospective, :id => @project.id and return
    end
  end

  # PATCH/PUT /retrospectives/1
  # PATCH/PUT /retrospectives/1.json
  def update
    respond_to do |format|
      if @retrospective.update(retrospective_params)
        format.html { redirect_to @retrospective, notice: 'Retrospective was successfully updated.' }
        format.json { render :show, status: :ok, location: @retrospective }
      else
        format.html { render :edit }
        format.json { render json: @retrospective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /retrospectives/1
  # DELETE /retrospectives/1.json
  def destroy
    @retrospective.destroy
    respond_to do |format|
      format.html { redirect_to retrospectives_url, notice: 'Retrospective was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retrospective
      @retrospective = Retrospective.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retrospective_params
      params.require(:retrospective).permit(:name, :description_good, :description_bad,
        :description_future, :sprint_id, :project_id)
    end
end
