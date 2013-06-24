module SakuraCloud
  class Server < SakuraCloud::AbstractModel
    PROPERTIES = [:id, :name, :host_name, :index, :description, :service_class, :created_at, :icon]
    CREATE_REQUIREMENTS = [:name]

    attr_reader   *(PROPERTIES - CREATE_REQUIREMENTS)
    attr_accessor *CREATE_REQUIREMENTS

    def self.all
      Response.new(get('/server'))[:servers].map do |server_info|
        new.tap do |server|
          self::PROPERTIES.map do |key|
            server.instance_variable_set("@#{key}", server_info[key])
          end
        end
      end
    end
  end
end
