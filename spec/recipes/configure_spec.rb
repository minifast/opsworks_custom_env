require "spec_helper"

describe "opsworks_custom_env::configure" do
  let(:chef) { ChefSpec::Runner.new }

  subject(:chef_run) { chef.converge(described_recipe) }

  before { Chef::Recipe.any_instance.stub(:include_recipe) }

  context "when the layers include a rails app" do
    before { chef.node.set[:opsworks][:instance][:layers] = ["rails-app"] }

    it "includes the restart_command recipe" do
      Chef::Recipe.any_instance.should_receive(:include_recipe).with("opsworks_custom_env::restart_command")
      chef_run
    end

    it "includes the restart_command recipe" do
      Chef::Recipe.any_instance.should_receive(:include_recipe).with("opsworks_custom_env::restart_command")
      chef_run
    end
  end

  context "when the layers do not include a rails app" do
    before { chef.node.set[:opsworks][:instance][:layers] = ["node-app"] }

    it "does not include recipes" do
      Chef::Recipe.any_instance.should_not_receive(:include_recipe)
      chef_run
    end
  end
end
