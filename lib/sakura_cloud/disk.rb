module SakuraCloud
  class Disk < AbstractModel

    class Plan
      attr_reader :type, :size_mb

      def self.all
        @plans ||= @__fetched_plans.map { |plan|
          plan[:size].map do |size|
            new(index: plan[:index], size: size[:display_size])
          end
        }.flatten
      end

      def initialize(opts={index: 0})
        self.class.instance_variable_get('@__fetched_plans')[opts[:index]].map do |plan_key, plan_val|
          instance_variable_set("@#{plan_key}", plan_val)
        end

        @size = opts[:size]
        @type = opts[:index] == 0 ? :ssd : :hdd
        @size_mb = 2 ** 10 * opts[:size]
      end
    end

    PROPERTIES = [:id, :name, :connection, :connection_order, :description,
                  :reinstall_count, :size_mb, :mibrated_mb, :created_at]
    CREATE_REQUIREMENTS = [:name]

    attr_reader   *(PROPERTIES - CREATE_REQUIREMENTS)
    attr_accessor *CREATE_REQUIREMENTS

    def initialize(opts={type: :hdd})
      unless [:hdd, :ssd].include?(opts[:type])
        raise SakuraCloud::Disk::NoPlanError, 'Given type is neithor :hdd nor :ssd'
      end

      if opts[:size] && Plan.all.none? {|p| p.type == opts[:type] && p.size == opts[:size] }
        raise SakuraCloud::Disk::NoPlanError, 'Given size is out of service'
      end

      # disk size is given size or mimum size of given type
      @index = opts[:type] == :ssd ? 0 : 1
      @size = opts[:size] || Plan.all.select {|p| p.type == opts[:type]}.first.size
    end

    def plan
      @plan ||= Plan.new(index: @index, size: @size)
    end

    def type
      plan.type
    end

    def size
      plan.size
    end

    def size_mb
      plan.size_mb
    end
  end
end
