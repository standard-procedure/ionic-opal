class Element < Browser::DOM::Element::Custom
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
    def custom_element tag_name
      def_custom tag_name, base_class: `HTMLElement`
    end
  end
end
