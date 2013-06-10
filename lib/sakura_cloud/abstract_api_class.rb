require_relative 'request'

module SakuraCloud
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
    end )
  end
end
