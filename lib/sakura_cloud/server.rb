require_relative 'request'

module SakuraCloud
  class Server
    extend Request

    def self.all
      Response.new(get('/server'))
    end
  end
end
