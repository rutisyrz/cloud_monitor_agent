class AppServersController < ApplicationController
  before_action :set_app_server, except: [:index, :new, :create]

  # GET /app_servers
  # GET /app_servers.json
  def index
    @app_servers = AppServer.all
  end

  # GET /app_servers/1
  # GET /app_servers/1.json
  def show
  end

  # GET /app_servers/new
  def new
    @app_server = AppServer.new
  end

  # GET /app_servers/1/edit
  def edit
  end

  # POST /app_servers
  # POST /app_servers.json
  def create
    @app_server = AppServer.new(app_server_params)

    respond_to do |format|
      if @app_server.save
        format.html { redirect_to @app_server, notice: 'App server was successfully created.' }
        format.json { render :show, status: :created, location: @app_server }
      else
        format.html { render :new }
        format.json { render json: @app_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_servers/1
  # PATCH/PUT /app_servers/1.json
  def update
    respond_to do |format|
      if @app_server.update(app_server_params)
        format.html { redirect_to @app_server, notice: 'App server was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_server }
      else
        format.html { render :edit }
        format.json { render json: @app_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_servers/1
  # DELETE /app_servers/1.json
  def destroy
    @app_server.destroy
    respond_to do |format|
      format.html { redirect_to app_servers_url, notice: 'App server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /app_servers/:id/start
  def start
    result = AwsApiHelper.new("get", "ec2", "start", {instance_id: @app_server.instance_id}).send_request
    respond_to do |format|
      if result["error"].blank?
        @app_server.update(status: 'started')
        format.html { redirect_to @app_server, notice: I18n.t("common.notice.server_started") }
        format.json { render :show, status: :ok, location: @app_server }
      else
        format.html { redirect_to @app_server, notice: I18n.t("common.error", code: result["error"]["code"], message: result["error"]["message"]) }
        format.json { render :show, status: :ok, location: @app_server }
      end
    end
  end

  # GET /app_servers/:id/stop
  def stop
    result = AwsApiHelper.new("get", "ec2", "stop", {instance_id: @app_server.instance_id}).send_request
    respond_to do |format|
      if result["error"].blank?
        @app_server.update(status: 'stopped')
        format.html { redirect_to @app_server, notice: I18n.t("common.notice.server_stopped") }
        format.json { render :show, status: :ok, location: @app_server }
      else
        format.html { redirect_to @app_server, notice: I18n.t("common.error", code: result["error"]["code"], message: result["error"]["message"]) }
        format.json { render :show, status: :ok, location: @app_server }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_server
      @app_server = AppServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_server_params
      params.require(:app_server).permit(:name, :instance_id, :status, :file_system, :volume_mount_path)
    end
end
