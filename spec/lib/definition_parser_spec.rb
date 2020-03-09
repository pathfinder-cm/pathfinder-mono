require 'rails_helper'

RSpec.describe DefinitionParser do
  let(:parser) { DefinitionParser.new }

  describe "#parse" do
    it "returns same object of object with no special keyword" do
      input = {}
      expect(parser.parse(input)).to eq(input)
    end
  end
end
