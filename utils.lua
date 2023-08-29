local utils = {}

function utils.split (inputstr, sep)
    if sep == nil then
    sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function utils.lastn (data, n)
    local result = {}
    if #data < n then
       return data
    end
    for i=#data-n+1, #data, 1 do
        table.insert(result, data[i])
    end
    return result
end

return utils