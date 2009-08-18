module Handcache
  
  def self.get(id)
    return CacheStore[id]
  end
  
  def self.compressed_get(id)
    cache_data = CacheStore[id]
    return nil unless cache_data
    return Marshal.load(ActiveSupport::Gzip.decompress(cache_data))
  end
    
  def self.get_and_set(id, options = {}, &block)
    cache_data = CacheStore[id]
    if cache_data
      return cache_data
    else
      data = block.call
      CacheStore.store(id, data, options)
      return data
    end
  end
  
  def self.compressed_get_and_set(id, options = {}, &block)
    cache_data = CacheStore[id]
    if cache_data
      return Marshal.load(ActiveSupport::Gzip.decompress(cache_data))
    else
      value = block.call
      data = ActiveSupport::Gzip.compress(Marshal.dump(value))
      CacheStore.store(id, data, options)
      return value
    end
    
end
  
end