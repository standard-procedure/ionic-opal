class Candidate < ViewModel
  attributes :course_id, :name, :full_name, :first_name, :last_name, :email

  def assessment
    @assessment ||= application.assessments.find course_id
  end

  def assessment= value
    @asessment = value
  end
end
