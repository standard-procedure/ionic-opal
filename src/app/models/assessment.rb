class Assessment < ViewModel
  attributes :account, :title

  def candidates
    @candidates ||= Signal.array_attribute []
    if @candidates.get.empty?
      application.candidates.where(assessment: self).then do |results|
        candidates.set results
      end
    end
    @candidates
  end
end
