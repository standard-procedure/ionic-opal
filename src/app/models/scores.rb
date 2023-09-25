require_relative "candidate"

class Scores
  def initialize application = Application.current
    @application = application
    @collection = {}
  end

  attr_reader :application

  def find id, fetch: true, **params
    id = id.to_i
    if @collection[id].nil?
      @collection[id] = Score.new application: application, id: id, **params
      if fetch && id != 0
        application.fetch(:get, "/scores/#{id}.json").then do |response|
          @collection[id].set response.json
        end
      end
    end
    @collection[id]
  end

  def where candidate:, page: 1
    application.fetch(:get, "/candidates/#{candidate.id}/scores.json?page=#{page}").then do |results|
      results.json.map do |data|
        find(data["id"], fetch: false, candidate: candidate).tap do |score|
          score.set data.merge(candidate: candidate)
        end
      end
    end
  end
end
