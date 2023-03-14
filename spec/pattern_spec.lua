--[[
Copyright (C) 2023 David Minnix

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]] --
local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/pattern')
require('tranquility/event')

describe("Pattern", function()
    describe("Create", function()
        it("should initialize with defaults", function()
            local p = Pattern:create()
            p = Pattern:create {}
            assert.are.same(p:query(State:create()), List:new())
        end)
    end)
    describe("New", function()
        it("should create with specified query",
            function()
                local p = Pattern:new(function(_)
                    return List:new({ Event:create() })
                end)
                local events = p:query(State:create())
                assert.are.same(events, List:new({ Event:create() }))
            end)


        it("should have a function declaring its type", function()
            local pattern = Pattern:new()
            assert.are.equal("tranquility.Pattern", pattern:type())
        end)
    end)
    describe("filterEvents", function()
        it("should return new pattern with events removed based on filter func", function()
            local whole1 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(2, 1))
            local part1 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1))
            local event1 = Event:new(whole1, part1, 1, {}, false)
            local whole2 = TimeSpan:new(Fraction:new(2, 3), Fraction:new(3, 1))
            local part2 = TimeSpan:new(Fraction:new(2, 3), Fraction:new(1, 1))
            local event2 = Event:new(whole2, part2, 2, {}, false)
            local events = List:new({ event1, event2 })
            local p = Pattern:new(function(_)
                return events
            end)
            local filterFunction = function(e)
                return e:value() == 1
            end
            local filteredPattern = p:filterEvents(filterFunction)
            local filteredEvents = filteredPattern:query()
            assert.are.equal(filteredEvents, List:new({ event1 }))
        end)
    end)
    describe("withQueryTime", function()
        it("should return new pattern whose query function will pass the query timespan through a function before mapping it to events"
            , function()

            local pat = Pure(5)
            local add1 = function(other)
                return other + Fraction:new(1)
            end

            local newPat = pat:withQueryTime(add1)
            local expectedEvents = List:new({
                Event:new(
                    TimeSpan:new(1, 2),
                    TimeSpan:new(2, 2),
                    5
                )
            })
            local actualEvents = newPat:queryArc(Fraction:new(0), Fraction:new(1))
            assert.are.equal(expectedEvents, actualEvents)
        end)
    end)
    describe("withQuerySpan", function()
        it("should return new pattern with that modifies query span with function when queried", function()
            local pat = Pure(5)
            local newPat = pat:withQuerySpan(function(span)
                return TimeSpan:new(span:endTime() + 0.5, span:endTime() + 0.5)
            end)
            local expectedEvents = List:new({
                Event:new(
                    TimeSpan:new(0.5, 1.5),
                    TimeSpan:new(0.5, 1.5),
                    5
                )
            })
            assert.are.equal(expectedEvents, newPat:queryArc(Fraction:new(0), Fraction:new(1)))
        end)
    end)

    describe("withEventTime", function()
        it("should return new pattern with function mapped over event times", function()

            local pat = Pure(5)
            local newPat = pat:withEventTime(function(time)
                return time + 0.5
            end)
            local expectedEvents = List:new({
                Event:new(
                    TimeSpan:new(0.5, 1.5),
                    TimeSpan:new(0.5, 1.5),
                    10
                )
            })
            assert.are.equal(expectedEvents, newPat:queryArc(0, 1))
        end)
    end)

    describe("splitQueries", function()
        it("should break a query that spans multiple cycles into multiple queries each spanning one cycle", function()
            local pat = Pattern:new(function(state)
                return List:new({ Event:new(state.span, state.span, "a") })
            end)
            local splitPat = pat:splitQueries()
            local expectedEventsPat = List:new({ Event:new(TimeSpan:new(0, 2), TimeSpan:new(0, 2), "a") })
            local expectedEventsSplit = List:new({
                Event:new(TimeSpan:new(0, 1), TimeSpan:new(0, 2), "a"),
                Event:new(TimeSpan:new(1, 2), TimeSpan:new(0, 2), "a")
            })
            assert.are.equal(expectedEventsPat, pat:queryArc(0, 2))
            assert.are.equal(expectedEventsSplit, splitPat:queryArc(0, 2))
        end)
    end)
    -- TODO: what is a more realistic test case than this?
    --describe("outerJoin", function()
    --    it("it should convert a pattern of patterns into a single pattern with time structure coming from the outer pattern"
    --        , function()
    --        local patOfPats = Pure(Fastcat(List:new({ Pure("a"), Pure("b") })))
    --        local expectedEvents = List:new({
    --            Event:new(
    --                TimeSpan:new(0, 1),
    --                TimeSpan:new(0, 1),
    --                "a"
    --            )
    --        })
    --        local actualEvents = patOfPats:outerJoin()
    --        assert.are.equal(expectedEvents, actualEvents:queryArc(0, 1))
    --    end)
    --end)
    describe("withValue", function()
        it("should return new pattern with function mapped over event values on query", function()
            local pat = Pure(5)
            local newPat = pat:withValue(function(v)
                return v + 5
            end)
            local expectedEvents = List:new({
                Event:new(
                    TimeSpan:new(Fraction:new(0), Fraction:new(1)),
                    TimeSpan:new(Fraction:new(0), Fraction:new(1)),
                    10
                )
            })
            assert.are.equal(expectedEvents, newPat:queryArc(Fraction:new(0), Fraction:new(1)))
        end)
    end)
    describe("onsetsOnly", function()
        it("should return only events where the start of the whole equals the start of the part", function()

            local whole1 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(2, 1))
            local part1 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1))
            local event1 = Event:new(whole1, part1, 1, {}, false)
            local whole2 = TimeSpan:new(Fraction:new(2, 3), Fraction:new(3, 1))
            local part2 = TimeSpan:new(Fraction:new(5, 6), Fraction:new(1, 1))
            local event2 = Event:new(whole2, part2, 2, {}, false)
            local events = List:new({ event1, event2 })
            local p = Pattern:new(function(_)
                return events
            end)

            local patternWithOnsetsOnly = p:onsetsOnly()

            assert.are.same(patternWithOnsetsOnly:query(State:new(TimeSpan:new(Fraction:new(0), Fraction:new(3)))),
                List:new({ event1 }))
        end)

        it("pure patterns should not behave like continuous signals... they should have discrete onsets", function()

            local p = Pure("bd")

            local patternWithOnsetsOnly = p:onsetsOnly()
            local expectedWhole = TimeSpan:new(Fraction:new(0), Fraction:new(1))
            local expectedPart = TimeSpan:new(Fraction:new(0), Fraction:new(1))
            local expectedEvent = Event:new(expectedWhole, expectedPart, "bd")
            local actualEvents = patternWithOnsetsOnly:query(State:new(TimeSpan:new(Fraction:new(0), Fraction:new(1))))
            assert.are.equal(actualEvents,
                List:new({ expectedEvent }))
            local querySpan = TimeSpan:new(Fraction:new(1, 16), Fraction:new(1))
            local state = State:new(querySpan)
            assert.are.equal(querySpan, state:span())
            actualEvents = patternWithOnsetsOnly:query(state)
            assert.are.equal(actualEvents,
                List:new({}))
        end)
    end)
    describe("Pure", function()
        it("should create Pattern of a single value repeating once per cycle", function()
            local atom = Pure(5)
            local expectedEvents = List:new({
                Event:new(TimeSpan:new(Fraction:new(0), Fraction:new(1)),
                    TimeSpan:new(Fraction:new(0), Fraction:new(1)), 5)
            })
            local actualEvents = atom:queryArc(Fraction:new(0), Fraction:new(1))
            assert.are.equal(actualEvents:length(), expectedEvents:length())
            assert.are.equal(actualEvents:at(1), expectedEvents:at(1))
            assert.are.same(actualEvents:at(1)._whole, expectedEvents:at(1)._whole)
            assert.are.same(actualEvents:at(1)._part, expectedEvents:at(1)._part)
            assert.are.same(actualEvents:at(1)._value, expectedEvents:at(1)._value)
            local expectedEvent = Event:new(TimeSpan:new(Fraction:new(0), Fraction:new(1)),
                TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1)), 5, {}, false)
            actualEvents = atom:query(State:new(TimeSpan:new(Fraction:new(1, 2), Fraction:new(1, 1))))
            assert.are.same(actualEvents, List:new({ expectedEvent }))
            assert.are.same(actualEvents:at(1)._part, expectedEvent._part)
            assert.are.same(actualEvents:at(1)._whole, expectedEvent._whole)
            assert.are.same(actualEvents:at(1)._value, expectedEvent._value)
        end)
    end)
    describe("Slowcat", function()
        it("should alternate between the patterns in the list, one pattern per cycle", function()
            local cattedPats = Slowcat({ Pure(1), Pure(2), 3 })
            local expectedEventsCycle1 = List:new({
                Event:new(
                    TimeSpan:new(0, 1),
                    TimeSpan:new(0, 1),
                    1
                )
            })
            assert.are.equal(expectedEventsCycle1, cattedPats:queryArc(0, 1))
            local expectedEventsCycle2 = List:new({
                Event:new(
                    TimeSpan:new(1, 2),
                    TimeSpan:new(1, 2),
                    2
                )
            })
            assert.are.equal(expectedEventsCycle2, cattedPats:queryArc(1, 2))

            local expectedEventsCycle3 = List:new({
                Event:new(
                    TimeSpan:new(0, 1),
                    TimeSpan:new(0, 1),
                    3
                )
            })
            assert.are.equal(expectedEventsCycle3, cattedPats:queryArc(2, 3))
            assert.are.equal(expectedEventsCycle1, cattedPats:queryArc(3, 4))
        end)
    end)
    describe("fast", function()
        it("should return a pattern whose events are closer together in time", function()
            local pat = Pure("bd")
            local expectedEvents = List:new({
                Event:new(TimeSpan:new(Fraction:new(0), Fraction:new(0.5)),
                    TimeSpan:new(Fraction:new(0), Fraction:new(0.5))
                    , "bd"),
                Event:new(TimeSpan:new(Fraction:new(0.5), Fraction:new(1)),
                    TimeSpan:new(Fraction:new(0.5), Fraction:new(1))
                    , "bd")
            })
            local actualEvents = pat:_fast(2):queryArc(Fraction:new(0), Fraction:new(1))
            assert.are.same(expectedEvents, actualEvents)

        end)

    end)

end)
