module SakuraCloud
  class Server < SakuraCloud::AbstractModel
    CREATE_REQUIREMENTS = [:name]
    attr_accessor *CREATE_REQUIREMENTS
  end
end
