module StrongParams
  class Params
    def self.parameterize(params)
      return params unless params.is_a?(Hash)

      params_processed = self.new
      params.each do |key, val|
        params_processed[key] = parameterize(val)
      end

      params_processed
    end

    def initialize
      @hash = {}
    end

    def require(key)
      raise "#{self.class}: param is missing: #{key}" unless self[key]
      self[key]
    end

    def permit(*keys)
      keys.map!(&:to_s)
      @hash.select { |key| keys.include? key }
    end

    def [](key)
      @hash[key.to_s]
    end

    def []=(key, val)
      @hash[key.to_s] = val
    end

    def inspect
      "#{@hash}"
    end
  end
end
