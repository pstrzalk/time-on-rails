class WorksController < ApplicationController
  before_action :set_work, only: %i[ show edit update start stop destroy ]
  before_action :authenticate_user!

  # GET /works or /works.json
  def index
    @works = Work.where(user: current_user)
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
      params.expect(work: [ :duration, :description, :date, :project_id ])
    end
end
