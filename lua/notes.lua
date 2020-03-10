-- lua 笔记

-- 一、{} 遍历
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

-- 二、安全访问
test = a and a.b and a.b.c and a.b.c.d
-- C# test = a.?b.?c.?d
-- lua 中使用
test = (((a or {}).b or {}).c or {}).d

-- 三、
-- C语言中的三目运算符 a ? b : c
-- lua中使用
a and b or c  --b不为false时等价
if not a then a = b end 等价于 a = a or b  -- lua中惯用写法.a为初始化时，用b进行初始化

-- 四、lua的8中基本类型
--[[ 
    nil, boolean, number(float, int ==> math.type()区分), string, userdata, function, 
    thread, table ==>用type区分 
--]]

-- 五、可变参数相关函数
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

--  六、I/O
-- io.read(0) 用于测试是否达到文件末尾。如果仍然有数据可读，返回空字符；否则，返回nil。