# Set up app's custom configuration in the environment.
# See https://forums.aws.amazon.com/thread.jspa?threadID=118107
include_recipe "opsworks_custom_env::restart_command"

node[:deploy].each do |application, deploy|
  
  custom_env_template do
    application application
    deploy deploy
    env node[:custom_env][application]
  end
  
end
