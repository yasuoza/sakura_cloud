require 'delegate'
require_relative 'abstract_model'

module SakuraCloud
  # Generate sakura cloud api model.
  # If the model has product information, defines Plan class under its class namespace.
  # All models inherit SakuraCloud::AbstractModel.
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
    const_set(class_name.camelize, Class.new(AbstractModel) do

      # Define list of instances class, like `ServerArray`, `DiskArray` and so on.
      SakuraCloud.const_set(class_name.camelize+"Array", Class.new(DelegateClass(Array)) do
        def initialize(list=[])
          super(list)
        end

        def inspect
          "#<#{self.class}: #{instance_variables.map{|k|"#{k}=#{instance_variable_get(k)}"}.join(', ')}: #{super}>"
        end
      end)

      # Define product information methods
      # See more: http://developer.sakura.ad.jp/cloud/api/1.0/product/
      if %w(server disk internet).include?(class_name)
        plans = Response.new(get("/product/#{class_name}"))[:"#{class_name}_plans"].select do |plan|
          plan[:availability] == 'available'
        end

        const_set("Plan", Class.new do
          attr_reader *plans.first.keys
          @__fetched_plans = plans

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
        METHOD
      end # endif

    end )
  end
end
