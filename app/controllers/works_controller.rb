class WorksController < ApplicationController
  before_action :set_work, only: %i[ show edit update start stop destroy ]
  before_action :authenticate_user!

  # GET /works or /works.json
  def index
    @project_options = Project.where(user: current_user).map { |p| [ p.name, p.id ] }
    if params[:project_id].present?
      @works = Work.where(user: current_user, project_id: params[:project_id]).order(id: :desc)
    else
      @works = Work.where(user: current_user).order(id: :desc)
    end
  end

  # GET /works/1 or /works/1.json
  def show
  end

  # GET /works/new
  def new
    @work = Work.new(date: Date.current)
    @work.user = current_user

    @project_options = Project.where(user: current_user).map { |p| [ p.name, p.id ] }
  end

  # GET /works/1/edit
  def edit
    @project_options = Project.where(user: current_user).map { |p| [ p.name, p.id ] }
  end

  # POST /works or /works.json
  def create
    @work = Work.new(work_params)
    @work.user = current_user
    @work.start unless @work.total_time > 0

    respond_to do |format|
      if @work.save
        format.html { redirect_to works_path, notice: "Work was successfully created." }
        format.json { render :show, status: :created, location: @work }
      else
        format.html {
          @project_options = Project.where(user: current_user).map { |p| [ p.name, p.id ] }

          render :new, status: :unprocessable_entity
        }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /works/1 or /works/1.json
  def update
    respond_to do |format|
      if @work.update(work_params)
        format.html { redirect_to works_path, notice: "Work was successfully updated." }
        format.json { render :show, status: :ok, location: @work }
      else
        format.html {
          @project_options = Project.where(user: current_user).map { |p| [ p.name, p.id ] }

          render :edit, status: :unprocessable_entity
        }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  def start
    respond_to do |format|
      @work.start

      if @work.save
        format.html { redirect_to works_path, notice: "Work was successfully started." }
        format.json { render :show, status: :ok, location: @work }
      else
        format.html { redirect_to works_path, notice: "Work was not started" }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  def stop
    respond_to do |format|
      @work.stop

      if @work.save
        format.html { redirect_to works_path, notice: "Work was successfully stopped." }
        format.json { render :show, status: :ok, location: @work }
      else
        format.html { redirect_to works_path, notice: "Work was not started" }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1 or /works/1.json
  def destroy
    @work.destroy!

    respond_to do |format|
      format.html { redirect_to works_path, status: :see_other, notice: "Work was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = Work.where(user: current_user).find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def work_params
    form_params = params.expect(work: [ :description, :duration_hours, :duration_minutes, :duration_seconds, :date, :project_id ])

    if form_params[:duration_hours].present? ||
       form_params[:duration_minutes].present? ||
       form_params[:duration_seconds].present?
      form_params[:duration] = form_params[:duration_hours].to_i * 3600 +
                               form_params[:duration_minutes].to_i * 60 +
                               form_params[:duration_seconds].to_i
    end

    form_params.delete(:duration_hours)
    form_params.delete(:duration_minutes)
    form_params.delete(:duration_seconds)
    form_params
  end
end
