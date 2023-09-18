class ViewModel < StandardProcedure::Signal::Attribute::Hash
  def id
    self[:id].to_i
  end

  class << self
    def find id
      collection_class.find id
    end

    def where page: 1
      collection_class.where page: page
    end

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

    def singular_name
      name.dehumpfiy
    end

    def collection_name
      name.dehumpfiy.to_plural
    end

    def collection_class
      collection_name.to_class
    end
  end
end
