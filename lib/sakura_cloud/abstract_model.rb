module SakuraCloud
  class AbstractModel

    attr_reader :errors

    extend Request
    include Request

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
        instances << allocate.init_with_code.tap do |ins|
          instance.each do |key, value|
            ins.instance_variable_set("@#{key}", value)
            ins.class.class_eval { attr_accessor key }
          end
        end
      end

      instances
    end

    def initialize(attributes={})
      @errors = []
      @__new_instance = true

      if defined?(self.class::Plan)
        # Ensure plan_id not to be nil
        attributes[:plan_id] ||= self.class::Plan.all.first.id
      end

      init_internals(attributes)
    end

    def init_internals(attributes={})
      attributes.map do |k, v|
        instance_variable_set('@' + k.to_s, v)
      end
    end

    def init_with_code(attributes={})
      @__new_instance = false

      init_internals(attributes)

      self
    end

    def plan
      @plan ||= self.class::Plan.new(plan_id: @plan_id)
    end

    def create(props={})
      new(props).save
    end

    def save
      raise NoMethodError, "#{self.class}#save is not implemented"
    end

    def new_record?
      @__new_instance
    end
  end
end
