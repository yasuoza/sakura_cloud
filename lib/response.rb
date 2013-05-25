module SakuraCloud
  class Server < Hash
    include Request
    attr_accessor :status, :is_ok, :result
    def initialize(server_id,opts={})
      @server_id = server_id
      @result=get("/server/#{@server_id}")
      self.merge!(@result["Server"])
      self["is_ok"]=@result["is_ok"]
      @result["Server"].each do |key,value|
        self.class.class_eval{define_method(key){self[key]}}
      end
    end
    def is_ok
      self["is_ok"]
    end
    def monitor
      @monitor ||= get("/server/#{@server_id}/monitor")
    end

  end
end

