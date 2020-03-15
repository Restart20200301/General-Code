-- lua 笔记

--[[    一、{} 遍历    ]]
arr = { 1, 2, 3, 4 }
-- 1.pairs 遍历出来顺序是随机的，且可能每次运行出来不一致。多用于作为字典时使用。
-- pairs可以遍历表中所有的key，并且除了迭代器本身以及遍历表本身还可以返回nil;
for _, v in pairs(arr) do
    io.write(v .. ' - ')
end
io.write('\n')
-- 2.ipairs 作为数组时使用。保证其顺序。
-- ipairs则不能返回nil,只能返回数字0，如果遇到nil则退出。它只能遍历到表中出现的第一个不是整数的key
for _, v in ipairs(arr) do
    io.write(v .. ' - ')
end
io.write('\n')
-- 3.for 作为数组时使用。保证其顺序。
for i = 1, #arr do
    io.write(arr[i] .. ' - ')
end
io.write('\n')

--[[   二、安全访问    ]]
test = a and a.b and a.b.c and a.b.c.d
-- C# test = a.?b.?c.?d
-- lua 中使用
test = (((a or {}).b or {}).c or {}).d

--[[   三、    ]]
-- C语言中的三目运算符 a ? b : c
-- lua中使用
--[[ 
    a and b or c  --b不为false时等价
    if not a then a = b end 等价于 a = a or b  -- lua中惯用写法.a为初始化时，用b进行初始化
]]

--[[   四、lua的8中基本类型    ]]
--[[ 
    nil, boolean, number(float, int ==> math.type()区分), string, userdata, function, 
    thread, table ==>用type区分 
--]]

--[[    五、可变参数相关函数   ]]
--[[ table.pack函数是获取一个索引从 1 开始的参数表 table，并会对这个 table 预定义一个字段 n，
表示该表的长度。--]] 
-- 与之相对的函数:table.unpack()。参数为数组，返回值为数组内的所有元素。
-- 例子：
function add(...)
    local sum = 0 
    local arg = table.pack(...)
    for i = 1, arg.n do
        sum = sum + arg[i]
    end
    return sum
end
-- select
--[[
    select(n, ...)  --数字n表示起点，select(n, ...)返回从起点n到结束的可变参数
    select('#', ...)  --返回可变参数的数量
--]]
function add(...)
    local sum = 0
    for i = 1, select('#', ...) do
        sum = sum + select(i, ...)
    end
    return sum
end

--[[    六、I/O    ]]
-- io.read(0) 用于测试是否达到文件末尾。如果仍然有数据可读，返回空字符；否则，返回nil。

--[[    七、瞬表   ]]
-- 定义：一个具有弱引用键和强引用值的表是一个瞬表。
-- 引用值中又引用了键的情况下，不计入键仍被引用。（避免了循环引用无法进行垃圾收集的尴尬场景）


--[[    七、协程    ]]
--[[
    线程与协程的主要区别：
    1.一个多线程程序可以并行运行多个线程
    2.而协程需要彼此协作地运行，即在任意指定的时刻只能有一个协程运行，且只有当正在运行的协程
      显式地被要求挂起时其执行才会暂停。
    协程的四种状态：(可以通过函数coroutine.status(thread)查看)
    1.挂起
    2.运行
    3.正常
    4.死亡
]] 
-- show code
local co = coroutine.create(function() print('hello, thread') end)
print(type(co))     --thread
print(coroutine.status(co))     --挂起(新创建的协程处于挂起状态不会自动运行)
coroutine.resume(co)    --启动或再次启动一个协程的执行
print(coroutine.status(co))     --死亡
-- yield函数挂起自己，然后用resume恢复执行
co = coroutine.create(function() 
    for i = 1, 10 do
        print('co', i)
        coroutine.yield()
    end
end)
coroutine.resume(co)
print('===回主线执行===')
print(coroutine.status(co))     --挂起
for i = 1, 10 do
    coroutine.resume(co)
end
print(coroutine.resume(co))     --false   cannot resume dead coroutine
--[[
    当协程A唤醒协程B时，协程A既不是挂起状态（因为不能唤醒协程A），也不是运行状态(因为正在运行的是协程B)。
    所以，协程A此时的状态就被称为正常状态。
]]
-- 生产者和消费者
function receive(prod)
    local status, val = coroutine.resume(prod)
    if not status then
        error(val)
    end
    return val
end

function send(x)
    coroutine.yield(x)
end

function producer()
    return coroutine.create(function()
        while true do
            local x = io.read()
            send(x)
        end
    end)
end

function filter(prod)
    return coroutine.create(function()
        for line = 1, math.huge do
            local x = receive(prod)
            x = string.format( "%5d %s", line, x)
            send(x)
        end
    end)
end

function consumer(prod)
    while true do
        local x = receive(prod)
        io.write(x, '\n')
    end
end

-- consumer(filter(producer()))
-- 生成所有排列的函数(协程版本)
function permgen(a, n)
    n = n or #a
    if n <= 1 then
        coroutine.yield(a)
    else
        for i = 1, n do
            a[i], a[n] = a[n], a[i]
            permgen(a, n - 1)
            a[i], a[n] = a[n], a[i]
        end
    end
end

function printRes(a)
    for i = 1, #a do
        io.write(a[i], ' ')
    end
    io.write('\n')
end

for p in coroutine.wrap(function() permgen({1, 2, 3}) end) do
    printRes(p)
end

for k, v in pairs(debug.getinfo(permgen)) do
    print(string.format( "%s: %s", k, v))
end

--[[    八、自省机制    ]]
function getvarvalue(name, level, isenv)
    level = (level or 1) + 1    -- 因为在getvarvalue中调用，所以level + 1
    -- 最先从局部变量中查找
    for i = 1, math.huge do
        local n, v = debug.getlocal(level, i)
        if not n then break end
        if n == name then return 'local', v end
    end
    -- 尝试查找upvalue
    local func = debug.getinfo(level, 'f').func
    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        if n == name then return 'upvalue', v end
    end
    
    if isenv then return 'noenv' end

    -- 从环境中查找
    local _, env = getvarvalue('_ENV', level, true)     -- level 之所以用这个是因为又嵌套了一层函数(getvarvalue)
    if env then
        return 'global', env[name]
    else
        return 'noenv'
    end
end
-- _ENV = _G
_ENV.aaa = 'test _ENV'
local a = 42; print(getvarvalue('a'))
print(string.format('_ENV.ttt = %s', _ENV.ttt))
ttt = 'xxxxxx'; print(getvarvalue('ttt'))
print(string.format('_ENV.ttt = %s', _ENV.ttt))
print(string.format('_G.ttt = %s', _G.ttt))
print(getvarvalue('aaa'))