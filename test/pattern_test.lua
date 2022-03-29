---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/pattern')

function TestPattern__create()
    local p = Pattern:create()

    p = Pattern:create{}
    lu.assertEquals(1,2)
end

--os.exit( lu.LuaUnit.run() )
