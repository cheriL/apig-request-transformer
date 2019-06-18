local typedefs = require "kong.db.schema.typedefs"

--add table define      --[head,query]:param:value
local constant_params_array = {
  type = "array",
  default = {},
  elements = { type = "string", match = "^[^:]+:[^:]+:.*$" },
}

--replace table define    --head:param1;body:json1.json2.param2
local params_map_array = {
  type = "array",
  default = {},
  elements = { type = "string", match = "^[^:]+:.+;[^:]+:.+$" },
}

--request param(path) array define
local params_request_path = {
  type = "array",
  default = {},
  elements = { type = "string", match = "^[^/]+$" },
}

return {
  name = "apig-request-transformer",
  fields = {
    --{ run_on = typedefs.run_on_first },
    --{ protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { httpMethod = typedefs.http_method },
          { backendContentType = { type = "string" } }, --"application/json"
          { requestPath = { type = "string" } },
          { backendPath = { type = "string" } },
          { pathParams = params_request_path },     
          { replace = params_map_array },
          { add  = constant_params_array },
        }
      },
    },
  }
}
