class Element < Browser::DOM::Element::Custom
  attr_accessor :contents

  def redraw
    Promise.new.tap do |promise|
      promise.resolve.then { render }
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
    @contents = inner_html
    redraw
    on_attached
  end

  def detached
    on_detached
  end

  def adopted
    @contents = inner_html
    redraw
    on_adopted
  end

  def attribute_changed attribute, old_value, new_value
    method = :"on_#{attribute}_changed"
    respond_to?(method) ? send(method, old_value, new_value) : on_changed(attribute, old_value, new_value)
  end

  class << self
    attr_reader :template_block

    def custom_element tag_name
      def_custom tag_name, base_class: `HTMLElement`
    end

    def template &block
      @template_block = block
    end
  end
end
