module SakuraCloud
  class Server < SakuraCloud::AbstractModel
    attr_accessor :name, :disk

    def save
      # Clear previous errors
      @errors = []

      post_params = {
        server: {
          name: self.name,
          zone: {id: SakuraCloud::Zone.all.first.id},
          server_plan: {id: self.plan.id}
        }
      }

      res = Response.new(post("/#{self.class.api_class}", post_params))

      if res[:is_fatal]
        @errors << res[:error_message]
        return false
      end

      res[:is_ok]
    end
  end
end
