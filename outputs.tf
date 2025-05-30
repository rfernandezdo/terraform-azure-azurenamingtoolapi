#  {"resourceName":"redis-spa-dev-auc-024","message":"","success":true,"resourceNameDetails":{"id":24,"createdOn":"2025-05-30T12:20:54.2521784+00:00","resourceName":"redis-spa-dev-auc-024","resourceTypeName":"Cache/Redis","components":[["ResourceType","redis"],["ResourceProjAppSvc","spa"],["ResourceEnvironment","dev"],["ResourceLocation","auc"],["ResourceInstance","024"]],"user":"API","message":""}}
#  {"resourceName":"***RESOURCE NAME NOT GENERATED***","message":"The name (redis-spa-dev-auc-023) you are trying to generate already exists. Please select different component options and try again.","success":false,"resourceNameDetails":{"id":0,"createdOn":"2025-05-30T12:20:16.7954838+00:00","resourceName":"","resourceTypeName":"","components":[],"user":"General","message":null}}

output "generated_name" {
  value = jsondecode(data.http.name_generation_post.response_body).resourceName != "***RESOURCE NAME NOT GENERATED***" ? jsondecode(data.http.name_generation_post.response_body).resourceName : regex("\\(([^)]*)\\)", jsondecode(data.http.name_generation_post.response_body).message)[0]
}

output "resource_name_not_generated" {
  value = jsondecode(data.http.name_generation_post.response_body).resourceName == "***RESOURCE NAME NOT GENERATED***" ? "RESOURCE NAME NOT GENERATED" : null
}

output "generated_name_id" {
  value = jsondecode(data.http.name_generation_post.response_body).resourceNameDetails.id

}
