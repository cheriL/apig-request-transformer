local _M = {}

local function reverse_table(tab)
    local revtab = {}
    for k, v in pairs(tab) do
        revtab[v] = k
    end
    return revtab
end

local function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

local function decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

function _M.parse_params(request_path, real_path, param_array)
    if not request_path or not next(param_array) then
        return
    end

    local params_map = {}
    local key_list = {}
    local value_list = {}

    --参数key的list
    for k in string.gmatch(request_path, "([^/]+)") do
        table.insert(key_list, k)
    end

    --翻转key_list
    key_list = reverse_table(key_list)

    --提取的value的list
    for v in string.gmatch(real_path, "([^/]+)") do
        local str = v
        --如果参数值经过urlEncode处理，则进行urlDecode.(转换后的请求到kong时也会被urlEncode)
        if string.find(str, "%%") ~= nil then
            str = decodeURI(str)
        end
        table.insert(value_list, str)
    end

    for i = 1, #param_array do
        local param = param_array[i]
        local pattern = "{" .. param .. "}"
        local pos = key_list[pattern]
        params_map[param] = value_list[pos]
    end

    return params_map
end


return _M
