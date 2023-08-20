module Await
  def await &block
    result = block.call
    return result unless result.is_a? Promise
    result.then do |value|
      return value
    end
  end
end
