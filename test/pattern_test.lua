---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/pattern')
require('src/time_span')
require('src/event')

function TestPattern__create()
    local p = Pattern:create()
    p = Pattern:create{}
    lu.assertEquals(p:query(TimeSpan:create()),{})
end

function TestPattern__new()
    local p = Pattern:new(function (timespan)
        return {Event:create()}
    end)
    local events = p:query(TimeSpan:create())
    lu.assertEquals(events,{Event:create()})
end

--os.exit( lu.LuaUnit.run() )
