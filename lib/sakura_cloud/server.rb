require_relative 'request'
require_relative 'response'
require_relative 'plan'

module SakuraCloud
  class Server
    extend Request

    PROPERTIES = [:id, :name, :hostname, :index, :description, :serverclass, :created_at, :icon]

    attr_reader *PROPERTIES

    def self.all
      Response.new(get('/server'))[:servers].map do |server|
        new server
      end
    end

    def initialize(server_info)
      @_server_info = server_info
      self.class::PROPERTIES.map do |key|
        instance_variable_set("@#{key}", server_info[key])
      end
    end

    def plan
      @plan ||= Plan.new(@_server_info[:server_plan])
    end
  end
end
