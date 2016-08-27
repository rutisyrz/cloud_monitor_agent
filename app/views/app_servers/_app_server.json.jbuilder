json.extract! app_server, :id, :name, :instance_id, :status, :file_system, :volume_mount_path, :created_at, :updated_at
json.url app_server_url(app_server, format: :json)