require 'rails_helper'

RSpec.describe DefinitionParser do
  let(:parser) { DefinitionParser.new }

  describe "#parse" do
    it "returns same object of object with no special keyword" do
      input = {}
      expect(parser.parse(input)).to eq(input)
    end

    it "parses passthrough function in Hash" do
      input = {
        "text": "$pf-meta:passthrough?value=text"
      }
      output = {
        "text": "text"
      }
      expect(parser.parse(input)).to eq(output)
    end

    it "parses passthrough function in Array" do
      input = ["$pf-meta:passthrough?value=text"]
      output = ["text"]
      expect(parser.parse(input)).to eq(output)
    end
  end
end
