require_relative "list_item"

class Accounts
  class List < Element
    property :accounts, type: :array, default: []
    property :page_number, type: :integer, default: 1
    property :list, type: :ruby

    def render
      inner_dom do |dom|
        dom.ion_list do
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
        end.created do |list|
          self.list = list
        end

        dom.ion_infinite_scroll do
          dom.ion_infinite_scroll_content
        end.on "ionInfinite" do |event|
          load_next_page.then do |accounts|
            event.target.complete
            event.target[:disabled] = accounts.empty?
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
      application.accounts.where(page: page_number).then do |results|
        self.accounts = accounts + results
        results
      end
    end

    def load_next_page
      self.page_number = page_number + 1
      load_accounts.then do |results|
        list.add_child do |dom|
          results.each do |account|
            render_account account, dom
          end
        end
        results
      end
    end

    custom_element "accounts-list"
  end
end
