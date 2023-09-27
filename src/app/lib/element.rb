require "date"
require "time"

class Element < Browser::DOM::Element::Custom
  def initialize node
    super node
    @attached = false
    @_properties = {}
  end
  attr_reader :_properties

  def render
  end

  module Implementation
    def attached?
      @attached
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
      @attached = true
      on_attached
      redraw
    end

    def detached
      @attached = false
      on_detached
    end

    def adopted
      @attached = true
      on_adopted
      redraw
    end

    def attribute_changed attribute, old_value, new_value
      attribute = attribute.snakeify
      method = :"#{attribute}_changed"
      respond_to?(method) ? send(method, old_value, new_value) : on_changed(attribute, old_value, new_value)
    end

    def redraw
      return if @redraw_scheduled
      @redraw_scheduled = true
      next_tick do
        @redraw_scheduled = false
        render if attached?
      end
    end

    # Type coercions
    # Ruby objects - leave them untouched
    # Otherwise convert into the given type, dealing with nils as appropriate
    def _convert value, type
      case type
      when :ruby then value
      when :array then value.nil? ? [] : value
      when :hash then value.nil? ? {} : value
      when nil then nil
      when :integer then value.to_i
      when :float then value.to_f
      when :text then value.to_s
      when :date then value.is_a?(Date) ? value : Date.parse(value)
      when :time then value.is_a?(Time) ? value : Time.new(value)
      else value
      end
    end
  end

  module Helpers
    def application
      Application.current
    end

    def router
      document["ion-router"]
    end

    def class_map classes = {}
      classes.collect { |key, value| key if value }.compact.map { |cls| cls.to_s.kebabify }.join(" ")
    end
  end

  module ClassMethods
    def property name, type: :text, default: nil
      native_attribute_name = name.to_s.kebabify
      native_property_name = name.to_s.camelify

      define_method name do
        # If we don't have a ruby property defined then create one
        # then check to see if there is a property on the underlying JS object
        # or an attribute set on the element
        # If neither has a value then use our default
        _properties[name] ||= _convert(@native.JS[native_property_name] || self[native_attribute_name] || default, type)
        _properties[name]
      end

      define_method :"#{name}=" do |value|
        value = _convert(value, type)
        _properties[name] = value
        # Keep the underlying JS object in sync unless we're storing a ruby object
        @native.JS[native_property_name] = value.to_n unless type == :ruby
        value
      end

      # Define the HTML attributes on the underlying element
      observed_attributes ||= []
      observed_attributes << native_attribute_name
    end

    def model model_name
      property model_name, type: :ruby
      alias_method model_name, :model
    end

    def custom_element tag_name
      def_custom tag_name, base_class: `HTMLElement`
    end
  end

  extend ClassMethods

  include Implementation
  include Helpers

  property :id
end
