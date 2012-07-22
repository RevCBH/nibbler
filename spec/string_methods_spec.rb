describe String do
  describe "#camelize" do
    it "capitalizes a simple string" do
      "foo".camelize.should == "Foo"
    end
  end
end