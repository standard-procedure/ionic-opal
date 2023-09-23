module Kernel
  def async &block
    Promise.new.tap do |promise|
      promise.resolve block.call
    rescue => ex
      promise.reject ex
    end
  end

  def next_tick &block
    Promise.new.tap do |promise|
      promise.resolve.then do
        block.call
      end
    end
  end
end
