class Score < ViewModel
  attributes :name, :full_name, :first_name, :last_name, :email
  belongs_to :assessment, :course_id
end
