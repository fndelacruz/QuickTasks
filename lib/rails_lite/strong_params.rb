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
      Params.parameterize(@hash.select { |key| keys.include? key })
    end

    def [](key)
      @hash[key.to_s]
    end

    def []=(key, val)
      @hash[key.to_s] = val
    end

    def each(&blk)
      @hash.each do |key, val|
        yield(key, val)
      end
      self
    end

    def inspect
      "#{@hash}"
    end
  end
end
