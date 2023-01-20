---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/pattern')
require('src/time_span')
require('src/event')

function TestPattern__create()
    local p = Pattern:create()
    p = Pattern:create {}
    lu.assertEquals(p:query(State:create()), {})
end

function TestPattern__new()
    local p = Pattern:new(function(state)
        return { Event:create() }
    end)
    local events = p:query(State:create())
    lu.assertEquals(events, { Event:create() })
end

function TestPattern__Pure()
    local atom = Pure(5)
    local expectedEvents = {
        Event:new(TimeSpan:new(Fraction:new(0), Fraction:new(1)),
            TimeSpan:new(Fraction:new(0), Fraction:new(1)), 5)
    }
    local actualEvents = atom:queryArc(Fraction:new(0),Fraction:new(1))
    lu.assertEquals(#(actualEvents), #(expectedEvents))
    lu.assertEquals(actualEvents[0], expectedEvents[0])
end

--os.exit( lu.LuaUnit.run() )
