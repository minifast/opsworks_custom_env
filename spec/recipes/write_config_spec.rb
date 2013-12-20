require "spec_helper"

describe "opsworks_custom_env::write_config" do
  let(:temp_path) { File.expand_path("../../../tmp", __FILE__) }
  let(:template_path) { File.expand_path("shared/config/application.yml", temp_path) }
  let(:chef) { ChefSpec::Runner.new }

  subject(:chef_run) { chef.converge(described_recipe) }

  context "when there is a deploy node" do
    let(:template_resource) { chef_run.template(template_path) }

    before do
      chef.node.set[:deploy][:app_name][:deploy_to] = temp_path
      chef.node.set[:custom_env][:app_name] = {"TACOS" => "okay"}
    end

    after { FileUtils.rm_rf(temp_path) }

    context "when there is a deploy directory" do
      before { FileUtils.mkdir_p(File.expand_path("shared/config", temp_path)) }

      it { should render_file(template_path).with_content(/TACOS: "okay"/) }
      specify { template_resource.should notify("execute[restart Rails app app_name for custom env]").to(:run) }
    end

    context "when there is no deploy directory" do
      before { FileUtils.rm_rf(temp_path) }

      it "does not write application.yml" do
        chef_run.should_not render_file(template_path)
      end
    end
  end

  context "when there is no deploy node" do
    before { chef.node.set[:deploy] = {} }

    it "does not write application.yml" do
      chef_run.should_not render_file(template_path)
    end
  end
end
