class Assessment < ViewModel
  attributes :title, :starting_on, :ending_on, :status
  belongs_to :account, :customer_id

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
