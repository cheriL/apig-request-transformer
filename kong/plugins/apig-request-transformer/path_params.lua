local _M = {}

function _M.parse_params(request_path, real_path, array)
    local params_value_array = {}

    local fake_path = request_path
    local params_key_array = array
    if not fake_path or not next(params_key_array) then
        return
    end
    
    local pattern = fake_path

    for i = 1, #params_key_array do
        local param_key = '%[' .. params_key_array[i] .. '%]'
        pattern = string.gsub(pattern, param_key, "([^/]+)")
    end

    for i = 1, #params_key_array do
        local param_key = params_key_array[i]
        params_value_array[param_key] = string.match(real_path, pattern)
        if params_value_array[param_key] then
            pattern = string.gsub(pattern, "%(%[%^%/%]%+%)", params_value_array[param_key], 1)
        end
    end

    return params_value_array
end

return _M
