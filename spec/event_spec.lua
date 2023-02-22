local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/event')

describe("Event", function()
    describe("constructors", function()
        it("shoud create with default values", function()
            local event = Event:create()
            assert.is_nil(event._whole)
            assert.are.equal(event._part, TimeSpan:new())
            assert.is_nil(event._value)
            assert.are.same(event._context, {})
            assert.are.equal(event._stateful, false)
        end)
        it('should new with arguments',


            function()
                local expectedWhole = TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1))
                local expectedPart = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
                local expectedContext = { field = "thing" }
                local expectedValue = 5
                local event = Event:new(
                    expectedWhole,
                    expectedPart,
                    expectedValue,
                    expectedContext,
                    false
                )
                assert.are.equals(event._whole, expectedWhole)
                assert.are.Equals(event._part, expectedPart)
                assert.are.Equals(event._value, expectedValue)
                assert.are.Equals(event._context, expectedContext)
                assert.is_false(event._stateful)

                assert.has_error(function() return Event:new(expectedWhole, expectedPart, expectedValue, expectedContext
                        , true)
                end)
            end)

    end)

    describe("duration", function()
        it("should return duration of event in cycles", function()
            local whole = TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1))
            local part = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
            local event = Event:new(whole, part, 5, {}, false)
            assert.are.equals(event:duration(), Fraction:new(1, 2))
        end)
    end)

    describe("wholeOrPart", function()
        it("should return whole if defined", function()
            local whole = TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1))
            local part = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
            local event = Event:new(whole, part, 5, {}, false)
            assert.are.equals(event:wholeOrPart(), whole)
        end)
        it("should return part if whole is not defined", function()
            local part = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
            local event = Event:new(nil, part, 5, {}, false)
            assert.are.equals(event:wholeOrPart(), part)
        end)
    end)

    describe("hasOnset", function()

        it("should report onset true if part and whole begin together", function()
            local whole = TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1))
            local part = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
            local event = Event:new(whole, part, 5, {}, false)
            assert.is_true(event:hasOnset())

            part = TimeSpan:new(Fraction:new(2, 3), Fraction:new(1, 1))
            event = Event:new(whole, part, 5, {}, false)
            assert.is_false(event:hasOnset())

            whole = TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1))
            part = TimeSpan:new(Fraction:new(2, 3), Fraction:new(3, 4))
            event = Event:new(whole, part, 5, {}, false)
            assert.is_false(event:hasOnset())

            part = TimeSpan:new(Fraction:new(2, 3), Fraction:new(3, 4))
            event = Event:new(nil, part, 5, {}, false)
            assert.is_false(event:hasOnset())
        end)

    end)

    describe("withSpan", function()
        it("should return new event with modified span",
            function()
                local oldPart = TimeSpan:new(Fraction:new(2, 3), Fraction:new(6, 5))
                local oldWhole = TimeSpan:new(Fraction:new(1, 2), Fraction:new(7, 5))
                local newPartAndWhole = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
                local changeSpan = function(_) return newPartAndWhole end
                local event = Event:new(oldWhole, oldPart, 5, {}, false)
                local newEvent = event:withSpan(changeSpan)
                assert.are.equals(newEvent._part, newPartAndWhole)
                assert.are.equals(newEvent._whole, newPartAndWhole)
                assert.are.equals(event._part, oldPart)

                event = Event:new(nil, oldPart, 5, {}, false)
                newEvent = event:withSpan(changeSpan)
                assert.are.equals(newEvent._part, newPartAndWhole)
                assert.is_nil(newEvent._whole)
                assert.are.equals(event._part, oldPart)
            end)

    end)

    describe("withValue", function()
        it("should return new event with modified value",
            function()
                local oldValue = 5
                local add1 = function(v) return v + 1 end
                local event = Event:new(nil, TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)), oldValue)
                local newEvent = event:withValue(add1)
                assert.are.equals(newEvent._value, 6)
            end)

    end)

    describe("spanEquals", function()
        it("should report if events share a part",
            function()
                local event1 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5
                )
                local event2 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(3, 4), Fraction:new(1, 1)),
                    5
                )
                assert.is_true(event1:spanEquals(event2))
                local event3 = Event:new(
                    TimeSpan:new(Fraction:new(0, 1), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5
                )
                assert.is_false(event1:spanEquals(event3))
                local event4 = Event:new(
                    nil,
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5
                )
                assert.is_false(event1:spanEquals(event4))
                local event5 = Event:new(
                    nil,
                    TimeSpan:new(Fraction:new(3, 4), Fraction:new(1, 1)),
                    6
                )
                assert.is_true(event4:spanEquals(event5))
            end)
    end)

    describe("equals", function()
        it("should compare all properties",
            function()
                local event1 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5,
                    {},
                    false
                )
                local event2 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5,
                    {},
                    false
                )
                assert.is_true(event1 == event2)
                local event3 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    6,
                    {},
                    false
                )
                assert.is_false(event1 == event3)
                local event4 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(3, 4), Fraction:new(1, 1)),
                    5,
                    {},
                    false
                )
                assert.is_false(event1 == event4)
                local event5 = Event:new(
                    TimeSpan:new(Fraction:new(3, 4), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5,
                    {},
                    false
                )
                assert.is_false(event1 == event5)
            end)

    end)
    describe("combineContext", function()
        it("should return new event with merged context tables",
            function()
                local event1 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5,
                    { thing1 = "something", thing2 = 5, locations = { 1, 2, 3 } },
                    false
                )

                local event2 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    6,
                    { thing1 = "something else", thing3 = "more cowbell", locations = { 4, 5, 6 } },
                    false
                )

                local expectedContext = { thing1 = "something else", thing2 = 5, thing3 = "more cowbell",
                    locations = { 1, 2, 3, 4, 5, 6 } }

                assert.are.same(event1:combineContext(event2), expectedContext)

                event1 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5,
                    { thing1 = "something", thing2 = 5, locations = { 1, 2, 3 } },
                    false
                )

                event2 = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    6,
                    { thing1 = "something else", thing3 = "more cowbell" },
                    false
                )

                expectedContext = { thing1 = "something else", thing2 = 5, thing3 = "more cowbell",
                    locations = { 1, 2, 3 } }

                assert.are.same(event1:combineContext(event2), expectedContext)
            end)

    end)

    describe("setContext", function()
        it("should return new event with specified context",
            function()
                local event = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5,
                    { thing = "something" },
                    false
                )
                local newContext = { thing2 = "something else" }
                local expectedEvent = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5,
                    newContext,
                    false
                )
                assert.are.same(event:setContext(newContext), expectedEvent)
            end)

    end)

    describe("show", function()
        it("should produce string representation of event times",
            function()
                local event = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(2, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    5
                )
                assert.are.equals(event:show(), "[(1/2 → 1/1) ⇝ |5]")
                event = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    6
                )
                assert.are.equals(event:show(), "[1/2 → 1/1 |6]")
                event = Event:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)),
                    TimeSpan:new(Fraction:new(3, 4), Fraction:new(1, 1)),
                    6
                )
                assert.are.equals(event:show(), "[(3/4 → 1/1) ⇜ |6]")
            end)

    end)
end)
