class Assessment < ViewModel
  attributes :account_id, :title

  def candidates
    @candidates ||= Signal.array_attribute []
    if @candidates.get.empty?
      application.candidates.where(assessment: self).then do |results|
        candidates.set results
      end
    end
    @candidates
  end

  def account
    @account ||= application.accounts.find account_id
  end

  attr_writer :account
end
