class Object
  def blank?
    false
  end

  def present?
    true
  end
end

class NilClass
  def blank?
    true
  end

  def present?
    false
  end
end

class String
  def blank?
    self == ""
  end

  def present?
    !blank?
  end

  def kebabify
    tr "_", "-"
  end

  def snakeify
    tr "-", "_"
  end

  def camelify
    first, *rest = split("_")
    first = first.downcase
    rest = rest.map(&:capitalize)
    ([first] + rest).join
  end
end

class Array
  def self.wrap items
    return [] if items.blank?
    return items if items.is_a? Array
    [items]
  end
end

class Browser::DOM::Node
  def value
    `#{@native}.value || nil`
  end
end

class Browser::DOM::Element
  alias_native :complete
end

class Paggio::HTML
  def method_missing(name, *args, &block) # standard:disable Style/MissingRespondToMissing
    return super if name.to_s.end_with? "!"
    name = name.to_s.kebabify.to_sym if name.to_s.include? "_"

    content = ::Paggio::Utils.heredoc(args.shift.to_s) unless args.empty? || ::Hash === args.first

    element = Element.new(self, name, *args)
    element << content if content

    if block
      parent = @current
      @current = element
      result = block.call(self)
      @current = parent

      element.instance_eval { @inner_html = result } if ::String === result
    end

    self << element

    element
  end
end

class Paggio::HTML::Element
  def initialize owner, name, attributes = {}
    @owner = owner
    @name = name
    @attributes = attributes.transform_keys { |key| key.to_s.kebabify }
    @children = []
    @class_names = attributes.delete(:class).to_s.split
  end
end
