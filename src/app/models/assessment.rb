class Assessment < ViewModel
  attributes :account, :title

  def candidates
    @candidates ||= Candidates.new storage, account: account, assessment: self
  end
end
