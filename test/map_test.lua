---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/map')

function TestMap()
    local list = {1,2,3}
    local add1 = function (v)
        return v+1
    end
    lu.assertEquals(Map(add1, list), {2,3,4})
end
