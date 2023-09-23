require_relative "assessments"

class Account < ViewModel
  attributes :name, :parent_id, :address, :telephone, :email, :url

  def assessments
    @assessments ||= Signal.array_attribute []
    if @assessments.get.empty?
      application.assessments.where(account: self).then do |results|
        @assessments.set results
      end
    end
    @assessments
  end

  def parent
    application.accounts.find parent_id
  end
end
