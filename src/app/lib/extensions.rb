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
  def self.inflector
    @inflector ||= Dry::Inflector.new
  end

  def blank?
    self == ""
  end

  def present?
    !blank?
  end

  def inflector
    self.class.inflector
  end

  def inflections
    inflector.send :inflections
  end

  def kebabify
    inflector.dasherize self
  end

  def snakeify
    input = gsub("::", "/")
    input = input.gsub(inflections.acronyms.regex) do
      m1 = Regexp.last_match(1)
      m2 = Regexp.last_match(2)
      "#{m1 ? "_" : ""}#{m2.downcase}"
    end
    input = input.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
    input = input.gsub(/([a-z\d])([A-Z])/, '\1_\2')
    input = input.tr("-", "_")
    input.downcase
  end

  def camelify upper = false
    input = sub(/^[a-z\d]*/) { |match| inflections.acronyms.apply_to(match, capitalize: upper) }
    input = input.gsub(%r{(?:[_-]|(/))([a-z\d]*)}i) do
      m1 = Regexp.last_match(1)
      m2 = Regexp.last_match(2)
      "#{m1}#{inflections.acronyms.apply_to(m2)}"
    end
    input.gsub("/", "::")
  end

  def dehumpify
    inflector.underscore self
  end
  alias_method :llamify, :dehumpify
  alias_method :alpacify, :dehumpify

  def to_plural
    inflector.pluralize self
  end
  alias_method :manyfy, :to_plural

  def to_singular
    inflector.singularize self
  end
  alias_method :alonify, :to_singular

  def to_class
    inflector.constantize self
  end
  alias_method :constantinople, :to_class
  alias_method :constantify, :to_class
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
