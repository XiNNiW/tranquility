---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/event')

function TestEvent__create()
    local event = Event:create()
    lu.assertNil(event._whole)
    lu.assertEquals(event._part, TimeSpan:new())
    lu.assertNil(event._value)
    lu.assertEquals(event._context, {})
    lu.assertEquals(event._stateful, false)
end

function TestEvent__new()
    local expectedWhole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    local expectedPart = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local expectedContext = {field="thing"}
    local expectedValue = 5
    local event = Event:new(
        expectedWhole,
        expectedPart,
        expectedValue,
        expectedContext,
        false
    )
    lu.assertEquals(event._whole, expectedWhole)
    lu.assertEquals(event._part, expectedPart)
    lu.assertEquals(event._value, expectedValue)
    lu.assertEquals(event._context, expectedContext)
    lu.assertFalse(event._stateful)

    lu.assertError(
        function (w,p,v,c,s) return Event:new(w,p,v,c,s) end,
        expectedWhole, expectedPart, expectedValue, expectedContext, true
    )
end

function TestEvent__duration()
    local whole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    local part = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local event = Event:new(whole, part, 5, {}, false)
    lu.assertEquals(event:duration(), Fraction:new(1,2))
end

function TestEvent__wholeOrPart()
    local whole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    local part = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local event = Event:new(whole, part, 5, {}, false)
    lu.assertEquals(event:wholeOrPart(), whole)
    event = Event:new(nil, part, 5, {}, false)
    lu.assertEquals(event:wholeOrPart(), part)
end

function TestEvent__hasOnset()
    local whole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    local part = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local event = Event:new(whole, part, 5, {}, false)
    lu.assertTrue(event:hasOnset())

    whole = TimeSpan:new(Fraction:new(1,2),Fraction:new(1,1))
    part = TimeSpan:new(Fraction:new(2,3),Fraction:new(3,4))
    event = Event:new(whole, part, 5, {}, false)
    lu.assertFalse(event:hasOnset())

    part = TimeSpan:new(Fraction:new(2,3),Fraction:new(3,4))
    event = Event:new(nil, part, 5, {}, false)
    lu.assertFalse(event:hasOnset())
end

function TestEvent__withSpan()
    local oldPart = TimeSpan:new(Fraction:new(2,3),Fraction:new(6,5))
    local oldWhole = TimeSpan:new(Fraction:new(1,2),Fraction:new(7,5))
    local newPartAndWhole = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local changeSpan = function(_) return newPartAndWhole end
    local event = Event:new(oldWhole, oldPart, 5, {}, false)
    local newEvent = event:withSpan(changeSpan)
    lu.assertEquals(newEvent._part, newPartAndWhole)
    lu.assertEquals(newEvent._whole, newPartAndWhole)
    lu.assertEquals(event._part, oldPart)

    event = Event:new(nil, oldPart, 5, {}, false)
    newEvent = event:withSpan(changeSpan)
    lu.assertEquals(newEvent._part, newPartAndWhole)
    lu.assertNil(newEvent._whole)
    lu.assertEquals(event._part, oldPart)
end

function TestEvent__withValue()
    local oldValue = 5
    local add1 = function(v) return v+1 end
    local event = Event:new(nil, TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)), oldValue)
    local newEvent = event:withValue(add1)
    lu.assertEquals(newEvent._value, 6)
end

function TestEvent__spanEquals()
    local event1 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        5
    )
    local event2 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(3,4), Fraction:new(1,1)),
        5
    )
    lu.assertTrue(event1:spanEquals(event2))
    local event3 = Event:new(
        TimeSpan:new(Fraction:new(0,1), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        5
    )
    lu.assertFalse(event1:spanEquals(event3))
    local event4 = Event:new(
        nil,
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        5
    )
    lu.assertFalse(event1:spanEquals(event4))
    local event5 = Event:new(
        nil,
        TimeSpan:new(Fraction:new(3,4), Fraction:new(1,1)),
        6
    )
    lu.assertTrue(event4:spanEquals(event5))
end

function TestEvent__equals()
    local event1 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        5,
        {},
        false
    )
    local event2 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        5,
        {},
        false
    )
    lu.assertTrue(event1 == event2)
    local event3 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        6,
        {},
        false
    )
    lu.assertFalse(event1 == event3)
    local event4 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(3,4), Fraction:new(1,1)),
        5,
        {},
        false
    )
    lu.assertFalse(event1 == event4)
    local event5 = Event:new(
        TimeSpan:new(Fraction:new(3,4), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        5,
        {},
        false
    )
    lu.assertFalse(event1 == event5)
end

function TestsEvent__combineContext()
    local event1 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        5,
        {thing1="something", thing2=5, locations= {1,2,3}},
        false
    )

    local event2 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        6,
        {thing1="something else", thing3="more cowbell", locations={ 4,5,6 }},
        false
    )

    local expectedContext = {thing1="something else", thing2=5, thing3= "more cowbell", locations={1,2,3,4,5,6}}

    lu.assertEquals(event1:combineContext(event2), expectedContext)

    event1 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        5,
        {thing1="something", thing2=5, locations= {1,2,3}},
        false
    )

    event2 = Event:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        TimeSpan:new(Fraction:new(1,2), Fraction:new(1,1)),
        6,
        {thing1="something else", thing3="more cowbell"},
        false
    )

    expectedContext = {thing1="something else", thing2=5, thing3= "more cowbell", locations={1,2,3}}

    lu.assertEquals(event1:combineContext(event2), expectedContext)
end
