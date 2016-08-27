class AppServer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :instance_id, type: String
  field :status, type: String
  field :file_system, type: String
  field :volume_mount_path, type: String

  validates :instance_id, :status, :file_system, :volume_mount_path, presence: true
  validates_uniqueness_of :instance_id
  
  has_many :server_monitor_logs

  index( {instance_id: 1}, {:background => true} )

  scope :running_instances, -> { where status: "started" }
  
  def started?
    status == "started"
  end

  def stopped?
    status == "stopped"
  end

end
