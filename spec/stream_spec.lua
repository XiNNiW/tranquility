local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/stream')
require('tranquility/pattern')

describe("Stream", function()
    describe("new", function()
        it("should construct with SuperDirt target", function()
            local stream = Stream:new()
            assert.are.same(stream.target, StreamTarget:new())
            assert.are.equal(stream._isPlaying, false)
            assert.are.equal(stream._latency, 0.2)
            assert.is_nil(stream._pattern)
        end)
    end)

    describe("notifyTick", function()
        it("should send osc message when called", function()
            --local stream = Stream:new()
            --stream._pattern = Pure("bd")
            --stream.notifyTick(0, 1, _, 0.5, 4, 10000, 333)
            assert.are.equal(1, 3, "don't you... forget about me")
        end)
    end)
end)
