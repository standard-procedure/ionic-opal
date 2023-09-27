class Candidate < ViewModel
  attributes :name, :full_name, :first_name, :last_name, :email, :scores
  belongs_to :assessment, :course_id
end
