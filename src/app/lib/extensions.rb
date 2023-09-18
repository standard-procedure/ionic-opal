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
