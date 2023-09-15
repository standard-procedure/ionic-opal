module Accounts
  class List < Element
    property :accounts, type: :array, default: []
    property :page_number, type: :integer, default: 1
    attr_reader :accounts_list

    def render
      inner_dom do |dom|
        dom.e "ion-content", class: "ion-padding" do
          @accounts_list = dom.e "ion-list" do
            if accounts.any?
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "Accounts"
                end
              end
              accounts.map(&:get).each do |account|
                render_account account, dom
              end
              dom.e "ion-infinite-scroll" do
                dom.e "ion-infinite-scroll-content"
              end.on "ionInfinite" do |event|
                load_next_page(event)
              end
            else
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "No accounts"
                end
              end
            end
          end
        end
      end
    end

    def render_account account, dom
      dom.e "ion-item", href: "/accounts/#{account["id"]}" do
        dom.e "ion-label" do
          account["name"].to_s
        end
      end
    end

    def on_attached
      load_accounts.then { redraw }
    end

    def load_accounts
      Promise.new.tap do |promise|
        Application.current.fetch(:get, "/accounts.json?page=#{page_number}").then do |response|
          self.accounts = accounts + response.json
          promise.resolve response.json
        end
      end
    end

    def load_next_page event
      self.page_number = page_number + 1
      load_accounts.then do |data|
        accounts_list << Browser::DOM::Builder.new do |dom|
          data.each do |account|
            render_account account, dom
          end
        end
        Native.call event.target.to_n, :complete
        event.target[:disabled] = (data.count == 0)
      end
    end

    custom_element "accounts-list"
  end
end
