local typedefs = require "kong.db.schema.typedefs"
--local validate_header_name = require("kong.tools.utils").validate_header_name

--add table define      --[head,query]:param:value
local constant_params_array = {
  type = "array",
  default = {},
  elements = { type = "string", match = "^[^:]+:[^:]+:.*$" },
}

--replace table define    --head:param1;query:param2
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

--replace配置不再支持body.涉及到body的转换使用 apig-json-creator
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
          { pathParams = params_request_path },  --请求path中的参数         
          { replace = params_map_array },
          { add  = constant_params_array },
        }
      },
    },
  }
}
