require 'test_helper'

class ServerMonitorLogsControllerTest < ActionController::TestCase
  setup do
    @server_monitor_log = server_monitor_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:server_monitor_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create server_monitor_log" do
    assert_difference('ServerMonitorLog.count') do
      post :create, server_monitor_log: { app_server_id: @server_monitor_log.app_server_id, cpu_usage: @server_monitor_log.cpu_usage, disk_usage_gb: @server_monitor_log.disk_usage_gb, disk_usage_percent: @server_monitor_log.disk_usage_percent, process_running: @server_monitor_log.process_running }
    end

    assert_redirected_to server_monitor_log_path(assigns(:server_monitor_log))
  end

  test "should show server_monitor_log" do
    get :show, id: @server_monitor_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @server_monitor_log
    assert_response :success
  end

  test "should update server_monitor_log" do
    patch :update, id: @server_monitor_log, server_monitor_log: { app_server_id: @server_monitor_log.app_server_id, cpu_usage: @server_monitor_log.cpu_usage, disk_usage_gb: @server_monitor_log.disk_usage_gb, disk_usage_percent: @server_monitor_log.disk_usage_percent, process_running: @server_monitor_log.process_running }
    assert_redirected_to server_monitor_log_path(assigns(:server_monitor_log))
  end

  test "should destroy server_monitor_log" do
    assert_difference('ServerMonitorLog.count', -1) do
      delete :destroy, id: @server_monitor_log
    end

    assert_redirected_to server_monitor_logs_path
  end
end
