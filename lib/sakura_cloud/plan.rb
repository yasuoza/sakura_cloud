module SakuraCloud
  class NoServerPlanError < ArgumentError; end

  class Plan

    include Request

    def initialize(opts = {id: 1})
      unless self.class.instance_variable_get("@_plans_fetched")
        plans = Response.new(get('/product/server'))[:server_plans].select { |plan|
          plan[:availability] == 'available'
        }

        self.class.class_eval do
          attr_reader *plans.first.keys
          self.const_set('PLANS', plans)
        end

        self.class.instance_variable_set("@_plans_fetched", true)
      end

      raise NoServerPlanError unless self.class::PLANS[opts[:id] - 1]

      self.class::PLANS[opts[:id] - 1].map { |key, val|
        self.instance_variable_set("@#{key}", val)
      }
    end
  end
end
