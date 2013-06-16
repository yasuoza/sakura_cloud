module SakuraCloud
  class Server
    extend Request

    PROPERTIES = [:id, :name, :hostname, :index, :description, :serverclass, :created_at, :icon]

    attr_reader *PROPERTIES

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
