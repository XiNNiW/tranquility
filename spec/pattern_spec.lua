local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/pattern')
require('tranquility/time_span')
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
                local p = Pattern:new(function(state)
                    return { Event:create() }
                end)
                local events = p:query(State:create())
                assert.are.same(events, { Event:create() })
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
