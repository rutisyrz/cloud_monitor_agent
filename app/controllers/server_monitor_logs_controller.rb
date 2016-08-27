class ServerMonitorLogsController < ApplicationController
  before_action :set_server_monitor_log, only: [:show, :edit, :update, :destroy]

  # GET /server_monitor_logs
  # GET /server_monitor_logs.json
  def index
    @server_monitor_logs = ServerMonitorLog.fetch_log(params) 
  end

  # GET /server_monitor_logs/1
  # GET /server_monitor_logs/1.json
  def show
  end

  # GET /server_monitor_logs/new
  def new
    @server_monitor_log = ServerMonitorLog.new
  end

  # GET /server_monitor_logs/1/edit
  def edit
  end

  # POST /server_monitor_logs
  # POST /server_monitor_logs.json
  def create
    @server_monitor_log = ServerMonitorLog.new(server_monitor_log_params)

    respond_to do |format|
      if @server_monitor_log.save
        format.html { redirect_to @server_monitor_log, notice: 'Server monitor log was successfully created.' }
        format.json { render :show, status: :created, location: @server_monitor_log }
      else
        format.html { render :new }
        format.json { render json: @server_monitor_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /server_monitor_logs/1
  # PATCH/PUT /server_monitor_logs/1.json
  def update
    respond_to do |format|
      if @server_monitor_log.update(server_monitor_log_params)
        format.html { redirect_to @server_monitor_log, notice: 'Server monitor log was successfully updated.' }
        format.json { render :show, status: :ok, location: @server_monitor_log }
      else
        format.html { render :edit }
        format.json { render json: @server_monitor_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /server_monitor_logs/1
  # DELETE /server_monitor_logs/1.json
  def destroy
    @server_monitor_log.destroy
    respond_to do |format|
      format.html { redirect_to server_monitor_logs_url, notice: 'Server monitor log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server_monitor_log
      @server_monitor_log = ServerMonitorLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def server_monitor_log_params
      params.require(:server_monitor_log).permit(:app_server_id, :cpu_usage, :disk_usage_percent, :disk_usage_gb, :process_running)
    end
end
