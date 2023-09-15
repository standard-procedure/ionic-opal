class Element < Browser::DOM::Element::Custom
  attr_reader :_properties

  def initialize node
    super node
    @_properties = {}
  end

  def redraw
    return if @redraw_scheduled
    @redraw_scheduled = true
    Promise.new.tap do |promise|
      promise.resolve.then do
        @redraw_scheduled = false
        render
      end
    end
  end

  def render
  end

  def on_attached
  end

  def on_detached
  end

  def on_adopted
  end

  def on_changed attribute, old_value, new_value
  end

  def attached
    redraw
    on_attached
  end

  def detached
    on_detached
  end

  def adopted
    redraw
    on_adopted
  end

  def attribute_changed attribute, old_value, new_value
    method = :"#{attribute}_changed"
    respond_to?(method) ? send(method, old_value, new_value) : on_changed(attribute, old_value, new_value)
  end

  def router
    document["ion-router"]
  end

  def custom_class
    self.class.custom_class
  end

  class << self
    def property name, type: :text, default: nil
      define_method name do
        # If we don't have a ruby property defined then create one
        # then check to see if there is a property on the underlying JS object
        # or an attribute set on the element
        # If neither has a value then use our default
        if _properties[name].nil?
          value = @native.JS[name] || self[name] || default
          _properties[name] = StandardProcedure::Signal::Attribute.send type, value
        end
        _properties[name].get
      end

      define_method :"#{name}=" do |value|
        _properties[name] ||= StandardProcedure::Signal::Attribute.send(type, default)
        _properties[name].set value
        # Keep the underlying JS object in sync
        @native.JS[name] = _properties[name].peek.to_n
        value
      end

      # Define the HTML attributes on the underlying element
      observed_attributes ||= []
      observed_attributes << name
    end

    def custom_element tag_name
      def_custom tag_name, base_class: `HTMLElement`
    end
  end
end
