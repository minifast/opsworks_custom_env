require "spec_helper"

describe "opsworks_custom_env::restart_command" do
  let(:chef) { ChefSpec::Runner.new }

  subject(:chef_run) { chef.converge(described_recipe) }

  context "when there is a deploy node" do
    before { chef.node.set[:deploy][:app_name][:deploy_to] = "/deploy" }

    it "sets up the rails app restart command" do
      chef_run.should declare_execute("restart Rails app app_name for custom env")
    end
  end

  context "when there is no deploy node" do
    before { chef.node.set[:deploy] = {} }

    it "does not declare a rails restart command" do
      chef_run.should_not declare_execute
    end
  end
end
