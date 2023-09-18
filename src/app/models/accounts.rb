require_relative "account"

class Accounts
  def initialize storage
    @storage = storage
    @collection = {}
  end

  attr_reader :collection
  attr_reader :storage

  def find id, fetch: true
    id = id.to_i
    if collection[id].nil?
      collection[id] = Account.new collection: self, id: id
      if fetch
        next_tick do
          storage.fetch(:get, "/account/#{id}.json").then do |response|
            collection[id].set response.json
          end
        end
      end
    end
    collection[id]
  end

  def where page: 1
    promise do
      storage.fetch(:get, "/accounts.json?page=#{page}").then do |response|
        response.json.collect do |data|
          find(data["id"], fetch: false).set data
        end
      end
    end
  end
end
