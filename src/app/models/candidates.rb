require_relative "account"
require_relative "assessment"
require_relative "candidate"

class Candidates
  def initialize storage, account:, assessment:
    @storage = storage
    @account = account
    @assessment = assessment
    @collection = {}
  end

  attr_reader :collection
  attr_reader :storage
  attr_reader :account
  attr_reader :assessment

  def find id, fetch: true
    id = id.to_i
    if collection[id].nil?
      collection[id] = Candidate.new collection: self, id: id, account: account, assessment: assessment
      if fetch
        next_tick do
          storage.fetch(:get, "/candidates/#{id}.json").then do |response|
            collection[id].set response.json
          end
        end
      end
    end
    collection[id]
  end

  def where page: 1
    promise do
      storage.fetch(:get, "/assessments/#{assessment.id}/candidates.json?page=#{page}").then do |response|
        response.json.collect do |data|
          find(data["id"], fetch: false).tap do |candidate|
            candidate.set data
          end
        end
      end
    end
  end
end
