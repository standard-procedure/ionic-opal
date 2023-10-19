require_relative "account"

class Accounts
  def initialize application = Application.current
    @application = application
    @collection = {}
  end

  attr_reader :collection
  attr_reader :application

  def where page: 1
    application.fetch(:get, "/accounts.json?page=#{page}").then do |response|
      response.json.collect do |data|
        find(data["id"], fetch: false).tap do |account|
          account.set data
        end
      end
    end
  end

  def get id
    async do
      find(id)
    end
  end

  def find id, fetch: true
    id = id.to_i
    if collection[id].nil?
      collection[id] = Account.new application: application, id: id
      if fetch && id != 0
        application.fetch(:get, "/accounts/#{id}.json").then do |response|
          collection[id].set response.json
        end
      end
    end
    collection[id]
  end
end
