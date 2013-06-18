require_relative 'request'

module SakuraCloud
  products = %w(server disk internet)

  %w[
     server
     disk
     archive
     switch
     cdrom
     internet
     ipaddress
     subnet
     interface
     packetfilter
     appliance
     icon
     sshkey
     region
     zone
  ].each do |class_name|
    const_set(class_name.camelize, Class.new do
      extend Request
      def self.api_class
        return @api_class if @api_class
        @api_class ||= self.to_s.scan(/[A-Za-z0-9_]+$/)[0].underscore
      end
      def self.all
        Response.new(get("/#{api_class}"))
      end

      if products.include?(class_name)
        plans = Response.new(get("/product/#{class_name}"))[:"#{class_name}_plans"].select do |plan|
          plan[:availability] == 'available'
        end

        const_set("Plan", Class.new do
          attr_reader *plans.first.keys

          class_eval <<-METHOD, __FILE__, __LINE__
            def self.all
              @plans ||= #{plans}.map do |plan|
                new(plan_id: plan[:id])
              end
            end

            def initialize(opts={plan_id: 1})
              #{plans}.select {|p| p[:id] == opts[:plan_id]}.first.map do |key, val|
                self.instance_variable_set('@' + key.to_s, val)
              end
            end
          METHOD
        end)

        class_eval <<-METHOD, __FILE__, __LINE__
          class NoPlanError < ArgumentError
            def initialize(msg='Given plan_id is out of #{class_name} plan') ; super(msg) ; end
          end

          def initialize(opts={plan_id: 1})
            @plan_id = opts[:plan_id]

            raise NoPlanError if self.class::Plan.all.select {|p| p.id == opts[:plan_id]}.empty?
          end

          def plan
            @plan ||= Plan.new(plan_id: @plan_id)
          end
        METHOD
      end
    end )
  end
end
