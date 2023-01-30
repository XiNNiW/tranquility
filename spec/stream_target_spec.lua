local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/stream_target')

describe("Target", function ()
    it("should default to SuperDirt settings", function ()
        local target = StreamTarget:new()
        assert.are.equal(target.name, "SuperDirt")
        assert.are.equal(target.address, "127.0.0.1")
        assert.are.equal(target.port, 57120)
        assert.are.equal(target.latency, 0.2)
        assert.is_true(target.handshake)
    end)
end)
