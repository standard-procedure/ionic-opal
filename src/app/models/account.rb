require_relative "assessments"

class Account < ViewModel
  attributes :name, :parent_id, :address, :telephone, :email, :url

  def assessments
    @assessments = Assessments.new storage, account: self
  end

  def parent
    collection.find parent_id
  end
end
