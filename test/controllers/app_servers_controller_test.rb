require 'test_helper'

class AppServersControllerTest < ActionController::TestCase
  setup do
    @app_server = app_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_server" do
    assert_difference('AppServer.count') do
      post :create, app_server: { file_system: @app_server.file_system, instance_id: @app_server.instance_id, name: @app_server.name, status: @app_server.status, volume_mount_path: @app_server.volume_mount_path }
    end

    assert_redirected_to app_server_path(assigns(:app_server))
  end

  test "should show app_server" do
    get :show, id: @app_server
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_server
    assert_response :success
  end

  test "should update app_server" do
    patch :update, id: @app_server, app_server: { file_system: @app_server.file_system, instance_id: @app_server.instance_id, name: @app_server.name, status: @app_server.status, volume_mount_path: @app_server.volume_mount_path }
    assert_redirected_to app_server_path(assigns(:app_server))
  end

  test "should destroy app_server" do
    assert_difference('AppServer.count', -1) do
      delete :destroy, id: @app_server
    end

    assert_redirected_to app_servers_path
  end
end
