require 'aws/decider'
require 'logger'

$RUBYFLOW_DECIDER_DOMAIN = "Recipes"
config_file = File.open('credentials.cfg') {|f| f.read}
AWS.config(YAML.load(config_file))

@swf = AWS::SimpleWorkflow.new
begin
    @domain = @swf.domains.create($RUBYFLOW_DECIDER_DOMAIN, "10")
rescue AWS::SimpleWorkflow::Errors::DomainAlreadyExistsFault => e
    @domain = @swf.domains[$RUBYFLOW_DECIDER_DOMAIN]
end
$swf, $domain = @swf, @domain #globalize them for use in tests

$EXCLUSIVE_CHOICE_WORKFLOW_TASK_LIST = "exclusive_choice_workflow_task_list"
$MULTI_CHOICE_WORKFLOW_TASK_LIST = "multi_choice_workflow_task_list"
$ACTIVITY_TASK_LIST = "choice_activity_task_list"

$logger = Logger.new(STDOUT)