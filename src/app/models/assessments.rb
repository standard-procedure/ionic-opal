require_relative "account"
require_relative "assessment"

class Assessments
  def initialize storage, account:
    @storage = storage
    @account = account
    @collection = {}
  end

  attr_reader :collection
  attr_reader :storage
  attr_reader :account

  def find id, fetch: true
    id = id.to_i
    if collection[id].nil?
      collection[id] = Assessment.new collection: self, id: id, account: account
      if fetch
        next_tick do
          storage.fetch(:get, "/accounts/#{account.id}/assessment/#{id}.json").then do |response|
            collection[id].set response.json
          end
        end
      end
    end
    collection[id]
  end

  def where page: 1
    promise do
      storage.fetch(:get, "/accounts/#{account.id}/assessments.json?page=#{page}").then do |response|
        response.json.collect do |data|
          find(data["id"], fetch: false).tap do |assessment|
            assessment.set data
          end
        end
      end
    end
  end
end
