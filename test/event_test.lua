---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/event')

function TestEvent__create()
    local event = Event:create()
    lu.assertEquals(event._whole, TimeSpan:new())
    lu.assertEquals(event._part, TimeSpan:new())
    lu.assertEquals(event._context, {})
    lu.assertEquals(event._stateful, false)
end

function TestEvent__new()
    local expectedWhole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    local expectedPart = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local event = Event:new(
        expectedWhole,
        expectedPart,
        {field="thing"},
        false
    )
    lu.assertEquals(event._whole, expectedWhole)
    lu.assertEquals(event._whole, expectedPart)
end

function TestEvent__duration()
    local whole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    local part = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local event = Event:new(whole, part, {}, false)
    lu.assertEquals(event:duration(), Fraction:new(1,2))
end

function TestEvent__wholeOrPart()
    local whole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    local part = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local event = Event:new(whole, part, {}, false)
    lu.assertEquals(event.wholeOrPart(), whole)
    event = Event:new(nil, part, {}, false)
    lu.assertEquals(event.wholeOrPart(), part)
end

function TestEvent__hasOnset()
    local whole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    local part = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local event = Event:new(whole, part, {}, false)
    lu.assertTrue(event:hasOnset())

    whole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    part = TimeSpan:new(Fraction:new(2,3),Fraction:new(3,4))
    event = Event:new(whole, part, {}, false)
    lu.assertFalse(event:hasOnset())

    part = TimeSpan:new(Fraction:new(2,3),Fraction:new(3,4))
    event = Event:new(nil, part, {}, false)
    lu.assertFalse(event:hasOnset())

end
