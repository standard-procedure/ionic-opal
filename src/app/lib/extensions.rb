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
end

class Browser::DOM::Node
  def value
    `#{@native}.value || nil`
  end
end
