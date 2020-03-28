local Utils = require './Utils'

function main( ... )
    str = "hello, world.. i'm test!!"
    local arr = Utils.Split(str)
    for _, word in ipairs(arr) do
        print(word)
    end
    io.write('\n')

    arr = Utils.Split(str, 'e')
    for _, word in ipairs(arr) do
        print(word)
    end
    io.write('\n')
end

main()