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

    def belongs_to model, attribute_name = nil
      collection = model.to_s.to_plural.to_sym
      model = model.to_sym
      attribute_name = attribute_name.to_sym

      attribute attribute_name, type: :integer

      define_method model do
        model_id = send attribute_name
        self[model] ||= application.send(collection).find model_id
      end

      define_method :"#{name}=" do |value|
        self[model] = value
      end
    end
  end
end
