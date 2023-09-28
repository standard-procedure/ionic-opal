class Candidate < ViewModel
  attributes :token, :name, :full_name, :first_name, :last_name, :email, :scores, :reports
  belongs_to :assessment, :course_id
end
