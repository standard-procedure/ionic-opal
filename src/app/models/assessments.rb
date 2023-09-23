require_relative "account"
require_relative "assessment"

class Assessments
  def initialize application = Application.current
    @application = application
    @collection = {}
  end

  attr_reader :application

  def find id, fetch: true, **params
    id = id.to_i
    if @collection[id].nil?
      @collection[id] = Assessment.new application: application, id: id, **params
      if fetch
        application.fetch(:get, "/assessments/#{id}.json").then do |response|
          @collection[id].set response.json
        end
      end
    end
    @collection[id]
  end

  def where account:, page: 1
    application.fetch(:get, "/accounts/#{account.id}/assessments.json?page=#{page}").then do |results|
      results.json.map do |data|
        find(data["id"], fetch: false, account: account).tap do |assessment|
          assessment.set data
        end
      end
    end
  end
end
