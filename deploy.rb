require 'aws-sdk'

task_family = ARGV[0]
service_name = ARGV[1]
cluster_name = ARGV[2]

ecs = Aws::ECS::Client.new

# pull the description of the latest registered task definition
current_task_def_descrip_resp = ecs.describe_task_definition({
                                                                 task_definition: task_family,
                                                             })

# create a new task definition identical to the existing one with a new auto-generates revision number and arn
ecs.register_task_definition({
                                 family: task_family,
                                 container_definitions: [
                                     current_task_def_descrip_resp.task_definition.container_definitions[0]
                                 ],
                             })

# update the server to use the new task definition
ecs.update_service({
                       service: service_name,
                       task_definition: task_family,
                       cluster: cluster_name,
                   })
