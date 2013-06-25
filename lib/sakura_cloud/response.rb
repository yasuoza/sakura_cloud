require 'multi_json'

module SakuraCloud
  class Response
    def self.new(json_response_str)
      @decoded_json =
        begin
          MultiJson.decode(json_response_str)
        rescue
          {is_ok: false, body: json_response_str}
        end

      hashnize(@decoded_json)
    end

    private

    def self.hashnize(maybe_hash_obj=@decoded_json)
      if maybe_hash_obj.respond_to?(:map)
        values =
          maybe_hash_obj.map do |k, v|
            if v.is_a?(Array)
              v.map { |_v| hashnize(_v) }
            elsif v.is_a?(Hash)
              hashnize(v)
            else
              v
            end
          end
        Hash[maybe_hash_obj.keys.map(&:underscore).map(&:to_sym).zip(values)]
      else
        maybe_hash_obj
      end
    end
  end
end

