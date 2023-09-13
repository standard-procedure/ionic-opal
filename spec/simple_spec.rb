describe StandardProcedure::Signal::Attribute do
  it "exists" do
    a = StandardProcedure::Signal::Attribute.text "Hello"
    expect(a).to_not be_nil
  end
end
