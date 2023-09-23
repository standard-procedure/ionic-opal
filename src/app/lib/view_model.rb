class ViewModel < StandardProcedure::Signal::Attribute::Hash
  attr_reader :application

  def initialize application:, **data
    @application = application
    super data
  end

  def id
    self[:id].to_i
  end

  def ready?
    id != 0
  end

  class << self
    def attributes *names
      names.each do |name|
        attribute name
      end
    end

    def attribute name
      define_method name do
        self[name]
      end

      define_method :"#{name}=" do |value|
        self[name] = value
      end
    end
  end
end
