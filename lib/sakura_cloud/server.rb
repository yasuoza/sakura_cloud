module SakuraCloud
  class Server < SakuraCloud::AbstractModel
    attr_accessor :name, :disk

    def save
      # Clear previous errors
      @errors = []

      raw_res = new_record? ? create_instance : update_instance

      res = Response.new(raw_res)

      if res[:is_fatal]
        @errors << res[:error_msg]
        return false
      end

      # Ensure to be an existing instance
      self.class.class_eval { attr_accessor *res[:server].keys }
      init_with_code(res[:server])

      res[:is_ok]
    end


    private

    def create_instance
      post("/#{self.class.api_class}", post_params)
    end

    def update_instance
      put("/#{self.class.api_class}/#{self.id}", post_params)
    end

    def post_params
      post_params = {
        server: {
          name: self.name,
          zone: {id: SakuraCloud::Zone.all.first.id},
          server_plan: {id: self.plan.id}
        }
      }
    end
  end
end
