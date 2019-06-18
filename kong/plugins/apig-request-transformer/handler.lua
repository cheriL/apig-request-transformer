local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.apig-request-transformer.access"

local apigRequestTransformerHandler = BasePlugin:extend()

function apigRequestTransformerHandler:new()
    apigRequestTransformerHandler.super.new(self, "apig-request-transformer")
end

function apigRequestTransformerHandler:access(conf)
    apigRequestTransformerHandler.super.access(self)
    access.execute(conf)
end

apigRequestTransformerHandler.PRIORITY = 802
apigRequestTransformerHandler.VERSION = "1.0.0"

return apigRequestTransformerHandler
