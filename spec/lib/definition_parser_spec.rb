require 'rails_helper'

RSpec.describe DefinitionParser do
  let(:deployment) { create(:deployment) }
  let(:context) { DefinitionContext.new(deployment, "#{deployment.name}-01") }
  let(:parser) { DefinitionParser.new }

  describe "#parse" do
    it "returns same object of object with no special keyword" do
      input = {}
      expect(parser.parse(context, input)).to eq(input)
    end

    it "raises error if function name is unknown" do
      input = "$pf-meta:unknown?value=text"

      expect { parser.parse(context, input) }.to raise_error(
        ArgumentError, "Unknown $pf-meta function name: unknown"
      )
    end

    describe "function passthrough" do
      it "handles function in Hash" do
        input = {
          "text": "$pf-meta:passthrough?value=text"
        }
        output = {
          "text": "text"
        }
        expect(parser.parse(context, input)).to eq(output)
      end

      it "handles function in Array" do
        input = ["$pf-meta:passthrough?value=text"]
        output = ["text"]
        expect(parser.parse(context, input)).to eq(output)
      end
    end

    describe "function deployment_ip_addresses" do
      let(:cluster) { create(:cluster) }

      before(:each) do
        @deployment = create(:deployment, cluster: cluster, name: 'hitsu-consul', count: 3)
        create(:container, cluster: cluster, hostname: 'hitsu-consul-01', ipaddress: nil)
        create(:container, cluster: cluster, hostname: 'hitsu-consul-04', ipaddress: '10.0.0.4')
        create(:container, cluster: cluster, hostname: 'hitsu-consul-03', ipaddress: '10.0.0.3')
        create(:container, cluster: cluster, hostname: 'hitsu-consul-02', ipaddress: '10.0.0.2')
      end

      it "returns array of deployment-managed IP addresses" do
        input = "$pf-meta:deployment_ip_addresses?deployment_name=hitsu-consul"
        output = ['10.0.0.2', '10.0.0.3']
        expect(parser.parse(context, input)).to eq(output)
      end
    end
  end
end
