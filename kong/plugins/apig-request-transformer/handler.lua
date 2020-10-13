local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.apig-request-transformer.access"
local kong = kong
local ngx = ngx

local apigRequestTransformerHandler = BasePlugin:extend()

function apigRequestTransformerHandler:new()
    apigRequestTransformerHandler.super.new(self, "apig-request-transformer")
end

function apigRequestTransformerHandler:access(conf)
    apigRequestTransformerHandler.super.access(self)

    local start_time = ngx.now()

    local request_table = {
        method = kong.request.get_method(),
        headers = kong.request.get_headers(),
        querys = kong.request.get_query(),
        path = kong.request.get_path()
    }

    local transformed_request_table = access.execute(request_table, conf)

    if transformed_request_table.method then
        kong.service.request.set_method(transformed_request_table.method)
    end
    if transformed_request_table.headers then
        kong.service.request.set_headers(transformed_request_table.headers)
    end
    if transformed_request_table.querys then
        kong.service.request.set_query(transformed_request_table.querys)
    end
    if transformed_request_table.path then
        kong.service.request.set_path(transformed_request_table.path)
    end

    ngx.update_time()
    kong.log.debug("[apig-request-transformer] spend time : ", (ngx.now() - start_time), ".")
end

apigRequestTransformerHandler.PRIORITY = 1999
apigRequestTransformerHandler.VERSION = "0.2.0"

return apigRequestTransformerHandler
