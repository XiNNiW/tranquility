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
require('tranquility/state')

describe("Pattern", function()
    describe("Create", function()
        it("should initialize with defaults", function()
            local p = Pattern:create()
            p = Pattern:create {}
            assert.are.same(p:query(State:create()), {})
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
            assert.are.same(actualEvents:at(1), expectedEvents:at(1))
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
    describe("fast", function()
        local pat = Pure("bd")
        local expectedEvents = {
            Event:new(TimeSpan:new(Fraction:new(0), Fraction:new(0.5)), TimeSpan:new(Fraction:new(0), Fraction:new(0.5))
                , "bd"),
            Event:new(TimeSpan:new(Fraction:new(0.5), Fraction:new(1)), TimeSpan:new(Fraction:new(0.5), Fraction:new(1))
                , "bd")
        }
        local actualEvents = pat:fast(2):queryArc(Fraction:new(0), Fraction:new(1))
        assert.are.same(expectedEvents, actualEvents)

    end)

end)
--os.exit( lu.LuaUnit.run() )
