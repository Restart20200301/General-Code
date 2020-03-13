-- 迭代器实践

-- ipair lua实现
local function iter(t, i)
    i = i + 1
    local v = t[t]
    if v then
        return i, v
    end
end

function ipairs(t)
    return iter, t, 0
end

-- pairs 实现依赖于lua的基本函数next
function pairs(t)
    retrun next, t, nil
end