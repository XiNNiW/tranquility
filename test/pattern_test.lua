---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/pattern')
require('src/time_span')
require('src/event')

function TestPattern__create()
    local p = Pattern:create()
    p = Pattern:create{}
    lu.assertEquals(p:query(State:create()),{})
end

function TestPattern__new()
    local p = Pattern:new(function (state)
        return {Event:create()}
    end)
    local events = p:query(State:create())
    lu.assertEquals(events,{Event:create()})
end

--os.exit( lu.LuaUnit.run() )
