module SakuraCloud
  class AbstractModel
    PROPERTIES = []
    CREATE_REQUIREMENTS = []

    extend Request

    def self.api_class
      @api_class ||= self.to_s.scan(/[A-Za-z0-9_]+$/)[0].underscore
    end

    def self.all
      Response.new(get("/#{api_class}"))
    end

    def initialize(opts={})
      if defined?(self.class::Plan)
        # Ensure plan_id not to be nil
        opts[:plan_id] ||= 1
        raise self.class::NoPlanError unless self.class::Plan.all.find {|p| p.id == opts[:plan_id]}
      end

      opts.map do |k, v|
        instance_variable_set('@' + k.to_s, v)
      end
    end

    def plan
      @plan ||= self.class::Plan.new(plan_id: @plan_id)
    end

    def create(props={})
      new(props).save
    end

    def save
      self.class::CREATE_REQUIREMENTS.each do |prop_key|
        raise ArgumentError, prop_key.to_s + ' property is requred' unless __send__(prop_key.to_sym)
      end

      # TODO: POST instance info

      true
    end
  end
end
