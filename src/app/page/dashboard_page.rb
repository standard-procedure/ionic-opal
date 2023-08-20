class DashboardPage < Element
  self.observed_attributes = %i[]

  def render
    inner_dom do |dom|
      dom.p "HELLO"
    end
  end

  custom_element "dashboard-page"
end
