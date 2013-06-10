module SakuraCloud
  class Plan
    MINIMUM_PLAN = { id: 1, name: 'Plan1', cpu: 1, memory_mb: 2048,
                            server_class: 'cloud/plan/1', availability: 'available' }

    attr_reader *MINIMUM_PLAN.keys

    def initialize(opts = {})
      MINIMUM_PLAN.each_pair do |key, default_val|
        instance_variable_set("@#{key}", opts[key] || opts[key.to_s] || default_val)
      end
    end
  end
end
