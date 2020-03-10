-- os.execute 执行系统命令
-- 还有个函数 io.popen()
function createDir(dirname)
    os.execute('mkdir ' .. dirname)
end

function createFile(path)
    os.execute('touch ' .. path)
end