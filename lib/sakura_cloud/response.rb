require 'multi_json'

module SakuraCloud
  class Response
    def self.new(json_response_str)
      json = MultiJson.decode(json_response_str)
      _response = super()
      _response.methodnize(json)
    end

    def methodnize(hash_obj)
      unless hash_obj.respond_to?(:map)
        hash_obj
      else
        values =
          hash_obj.map do |k, v|
            if v.is_a?(Array)
              v.map { |_v| methodnize(_v) }
            elsif v.is_a?(Hash)
              methodnize(v)
            else
              v
            end
          end
        klass = Struct.new(*hash_obj.keys.map(&:to_sym))
        klass.new(*values)
      end
    end
  end
end

