require 'multi_json'

module SakuraCloud
  class Response
    def self.new(json_response_str)
      decoded_json =
        begin
          MultiJson.decode(json_response_str)
        rescue
          {is_ok: false, body: json_response_str}
        end

      methodnize(decoded_json)
    end

    private

    def self.methodnize(maybe_hash_obj=@decoded_json)
      if maybe_hash_obj.respond_to?(:map)
        values =
          maybe_hash_obj.map do |k, v|
            if v.is_a?(Array)
              v.map { |_v| methodnize(_v) }
            elsif v.is_a?(Hash)
              methodnize(v)
            else
              v
            end
          end
        klass = Struct.new(*maybe_hash_obj.keys.map(&:downcase).map(&:to_sym))
        klass.new(*values)
      else
        maybe_hash_obj
      end
    end
  end
end

