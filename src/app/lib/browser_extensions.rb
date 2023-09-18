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

  def created &block
    @created = block
  end
end

Browser::DOM::Builder.for Paggio::HTML::Element do |b, item|
  options = {}

  options[:attrs] = `item.attributes` if Hash === `item.attributes`
  options[:classes] = `item.class_names`

  dom = b.document.create_element(`item.name`, **options)
  if (on = `item.on || nil`)
    on.each do |args, block|
      dom.on(*args, &block)
    end
  end
  if (inner = `item.inner_html || nil`)
    dom.inner_html = inner
  else
    item.each do |child|
      dom << Browser::DOM::Builder.build(b, child)
    end
  end
  if (created = `item.created || nil`)
    created.call dom
  end

  dom
end
