-- 元表与元方法的一些使用


-- 1、只读表
function readOnly(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(t, k, v) 
            error("can not update read-only table", 2)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end
-- for example:
local values = readOnly{ 1, k = 'v' }
print(values[1] .. '\t' .. values.k)    -- 1 v
-- values[1] = 10


-- 2、具有默认值的表
local k = {}
local mt = { __index = function(t) return t[k] end }
function setDefault(t, v)
    t[k] = v
    setmetatable(t, mt)
end
-- 例子:
values = { k = 'v'}
setDefault(values, 'vv')
print(values['k'], values[v])    --v  vv


-- 3、跟踪对表的访问
function track(t)
    local proxy = {}
    local mt = {
        __index = function(_, k)
            print('访问的key：' .. tostring(k))
            return t[k]
        end,
        __newindex = function(_, k, v)
            print('修改Key（' .. tostring(k) .. '）对应的值为' .. tostring(v))
            t[k] = v
        end,
        __pairs = function()
            return function(_, k)
                local nextkey, nextval = next(t, k)
                if nextkey ~= nil then
                    print('访问的key：' .. tostring(nextkey) .. ' Val: ' .. tostring(nextval))
                end
                return nextkey, nextval
            end
        end,
        __len = function() return #t end
    }
    setmetatable(proxy, mt)
    return proxy
end

values = {}
values = track(values)
values[10] = 100
print(values[10])
for k, v in pairs(values) do
    print(k, v)
end

-- 4、禁止查看和修改元表
local t = {}
local mt = {
    __index = function()
        return 0
    end
}
setmetatable(t, mt)
mt.__metatable = 'not get and not set'
-- 测试
print(getmetatable(t))
print(t[100])
-- print(setmetatable(t, {}))