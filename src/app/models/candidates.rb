require_relative "account"
require_relative "assessment"
require_relative "candidate"

class Candidates
  def initialize application = Application.current
    @application = application
    @collection = {}
  end

  attr_reader :application

  def find id, fetch: true
    id = id.to_i
    if @collection[id].nil?
      @collection[id] = Candidate.new application: application, id: id
      if fetch
        application.fetch(:get, "/candidates/#{id}.json").then do |response|
          @collection[id].set response.json
        end
      end
    end
    @collection[id]
  end

  def where assessment:, page: 1
    application.fetch(:get, "/assessments/#{assessment.id}/candidates.json?page=#{page}").then do |response|
      response.json.collect do |data|
        find(data["id"], fetch: false).tap do |candidate|
          candidate.set data.merge(assesment: assessment)
        end
      end
    end
  end
end
