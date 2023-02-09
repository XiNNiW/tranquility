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
                    return { Event:create() }
                end)
                local events = p:query(State:create())
                assert.are.same(events, { Event:create() })
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
            local events = { event1, event2 }
            local p = Pattern:new(function(_)
                return events
            end)
            local filterFunction = function(e)
                return e:value() == 1
            end
            local filteredPattern = p:filterEvents(filterFunction)
            local filteredEvents = filteredPattern:query()
            assert.are.same(filteredEvents, { event1 })
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
            local events = { event1, event2 }
            local p = Pattern:new(function(_)
                return events
            end)

            local patternWithOnsetsOnly = p:onsetsOnly()

            assert.are.same(patternWithOnsetsOnly:query(), { event1 })
        end)
    end)
    describe("Pure", function()
        it("should create Pattern of a single value repeating once per cycle",

            function()
                local atom = Pure(5)
                local expectedEvents = {
                    Event:new(TimeSpan:new(Fraction:new(0), Fraction:new(1)),
                        TimeSpan:new(Fraction:new(0), Fraction:new(1)), 5)
                }
                local actualEvents = atom:queryArc(Fraction:new(0), Fraction:new(1))
                assert.are.equal(#(actualEvents), #(expectedEvents))
                assert.are.equal(actualEvents[0], expectedEvents[0])
            end
        )
    end)

end)
--os.exit( lu.LuaUnit.run() )
