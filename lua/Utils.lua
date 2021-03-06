local Utils = {}

-- 仅能适用于根据单个字符拆分
function Utils.Split(str, delimiter)
    delimiter = delimiter or '%s'
    local strs = {}
    for s in string.gmatch(str, "[^" .. delimiter .. "]+") do
        table.insert(strs, s)
    end
    return strs
end

function Utils.IsEmptyString(str)
    return str == nil or str == ""
end

return Utils