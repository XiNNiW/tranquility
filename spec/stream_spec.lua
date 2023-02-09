local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/stream')

describe("Stream", function()
    describe("new", function()
        it("should construct with SuperDirt target", function()
            local stream = Stream:new()
            assert.are.same(stream.target, StreamTarget:new())
        end)
    end)

    describe("notifyTick", function()
        it("should send osc message when called", function()
            assert.are.equal(1, 3)
        end)
    end)
end)
