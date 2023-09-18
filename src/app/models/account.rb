class Account < ViewModel
  attr_reader :collection
  attributes :name, :parent_id, :address, :telephone, :email, :url

  def initialize collection:, **data
    @collection = collection
    super data
  end

  def parent
    collection.find parent_id
  end
end
