# 2.3 用Shell通配符匹配字符串
from fnmatch import fnmatch, fnmatchcase
print(fnmatch('foo.txt', '*.txt'))
# fnmatch 使用底层操作系统的大小写敏感规则来进行匹配模式
print(fnmatch('foo.txt', '?oo.*'))
print(fnmatch('foo45.txt', 'foo[0-9]*.txt'))
names = ['data02', 'data45', 'date45']
print([name for name in names if fnmatch(name, 'data*')])


# 2.5 字符串搜索与替换
text = 'Today is 3/30/2020. PyCon starts 3/13/2013.'
import re
text = re.sub(r'(\d+)/(\d+)/(\d+)', r'\3-\1-\2', text)
print(text)
datepattern = re.compile(r'(\d+)-(\d+)-(\d+)')
text = datepattern.sub(r'\2.\3.\1', text)
print(text)

# 2.7 最短匹配模式
# 默认贪婪
str_pat = re.compile(r'\"(.*)\"')
text = 'Computer says "no." Phone says "yes."'
res = str_pat.findall(text)
print(res)
# 通过在*或者+后，添加?获得最短的匹配（取消贪婪）
res = re.findall(r'\"(.*?)\"', text)
print(res)


# 8.3 让对象支持上下文管理协议
# 兼容with  实现 __enter__ 与 __exit()__ 。
# __enter__ 返回值最为as后对象。如 with file.open() as file。


# 8.4 创建大对象时节省内存方法
# 使用 __slots__ ，固定数组保存属性，否则使用的是字典。 定义了__slots__会失去一些普通类特性，如多继承。


# 8.5 在类中封装属性名
# 单下划线或者双下划线。 双下划线通过继承无法覆盖。