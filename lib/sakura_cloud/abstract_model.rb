module SakuraCloud
  class AbstractModel

    extend Request

    def self.api_class
      @api_class ||= self.to_s.scan(/[A-Za-z0-9_]+$/)[0].underscore
    end

    def self.all(opts = {})
      response = Response.new(get("/#{api_class}", opts))
      instances = SakuraCloud.const_get("#{api_class.camelize}Array").new

      (response.keys-["#{api_class}s".to_sym]).each do |key|
        instances.instance_variable_set("@#{key}", response[key])
        instances.class.class_eval { attr_accessor key }
      end

      response["#{api_class}s".to_sym].each do |instance|
        instances << new.tap do |ins|
          instance.each do |key, value|
            ins.instance_variable_set("@#{key}", value)
            ins.class.class_eval { attr_accessor key }
          end
        end
      end

      instances
    end

    def initialize(opts={})
      if defined?(self.class::Plan)
        # Ensure plan_id not to be nil
        opts[:plan_id] ||= self.class::Plan.all.first.id
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
