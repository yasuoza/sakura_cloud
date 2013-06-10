require 'multi_json'
require_relative 'util'

module SakuraCloud
  class Response
    def self.new(json_response_str)
      @decoded_json =
        begin
          MultiJson.decode(json_response_str)
        rescue
          {is_ok: false, body: json_response_str}
        end

      methodnize(@decoded_json)
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
        Hash[maybe_hash_obj.keys.map(&:underscore).map(&:to_sym).zip(values)]
      else
        maybe_hash_obj
      end
    end
  end
end

