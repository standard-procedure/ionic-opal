class Account < StandardProcedure::Signal::Attribute::Hash
  def initialize id:, name: "", address: "", telephone: "", email: "", url: ""
    super id: id, name: name, address: address, telephone: telephone, email: email, url: url
  end
end
