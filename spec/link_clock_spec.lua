local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/link_clock')

describe("LinkClock", function()
    describe("construction", function()
        it("should create with defaults", function()
            local clock = LinkClock:new()
            assert.are.equal(clock.bpm, 120)
            assert.are.equal(clock.sampleRate, 1 / 20)
            assert.are.equal(clock.beatsPerCycle, 4)
            assert.are.equal(clock._isRunning, false)
            assert.are.same(clock._subscribers, {})
        end)
    end)
    describe("subscribe/unsubscribe", function()
        it("should add/remove to list of subscribers", function()
            local clock = LinkClock:new(120)
            local mySub = { I = "am a subscriber" }
            clock:subscribe(mySub)
            assert.are.equal(#(clock._subscribers), 1)
            assert.are.equal(clock._subscribers[1], mySub) -- lua is 1 indexed... i will remember... lol
            local mySub2 = { I = "am the 2nd" }
            clock:subscribe(mySub2)
            assert.are.equal(#(clock._subscribers), 2)
            assert.are.equal(clock._subscribers[1], mySub)
            assert.are.equal(clock._subscribers[2], mySub2)
            clock:unsubscribe(mySub)
            assert.are.equal(#(clock._subscribers), 1)
            assert.are.equal(clock._subscribers[1], mySub2)
        end)
    end)
end)
