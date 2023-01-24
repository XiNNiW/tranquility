local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/stream')

describe("stream", function()
    it("should work", function()
        assert.are.equal(FirstOsc(), 1)
    end)
end)
