require_relative "list_item"

class Accounts
  class List < Element
    property :accounts, type: :array, default: []
    property :page_number, type: :integer, default: 1

    def render
      inner_dom do |dom|
        dom.ion_content class: "ion-padding" do
          dom.ion_list id: "accounts-list" do
            if accounts.any?
              dom.ion_list_header do
                dom.ion_label { "Accounts " }
              end
              accounts.each do |account|
                render_account account, dom
              end
            else
              dom.ion_list_header do
                dom.ion_label { "No accounts" }
              end
            end
          end
          dom.ion_infinite_scroll do
            dom.ion_infinite_scroll_content
          end.on "ionInfinite" do |event|
            load_next_page.then do |data|
              event.target.complete
              event.target[:disabled] = data.empty?
            end
          end
        end
      end
    end

    def render_account account, dom
      dom.account_list_item(account_id: account.id, name: account.name).created do |list_item|
        list_item.account = account
      end
    end

    def on_attached
      load_accounts.then do
        redraw
      end
    end

    def load_accounts
      promise do
        application.accounts.where(page: page_number).then do |results|
          self.accounts = accounts + results
          results
        end
      end
    end

    def load_next_page
      self.page_number = page_number + 1
      load_accounts.then do |data|
        at_css("#accounts-list").add_child do |dom|
          data.each do |account|
            render_account account, dom
          end
        end
        data
      end
    end

    custom_element "accounts-list"
  end
end
