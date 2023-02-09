local busted = require "busted"
local describe = busted.describe
local it = busted.it
local after_each = busted.after_each
require('tranquility.compare_tables')
require('tranquility.pattern')
require('tranquility.pattern_factory')


describe("p", function()
    after_each(function()
        Hush()
    end)
    it("should add a pattern to the global list of streams",
        function()
            assert.are.equal(#(Streams), 0)
            local expectedPattern = Pure("gabba")
            local pattern = P(1, expectedPattern)
            assert.are.equal(TableSize(Streams), 1)
            assert.are.equal(Streams[1]._pattern, expectedPattern)
            assert.are.equal(expectedPattern, pattern)
            local expectedPattern2 = Pure("bd")
            local pattern2 = P("two", expectedPattern2)
            assert.are.equal(TableSize(Streams), 2)
            assert.are.equal(Streams["two"]._pattern, expectedPattern2)
            assert.are.equal(expectedPattern2, pattern2)
        end
    )
    it("should replace stream if key already exists",
        function()
            assert.are.equal(#(Streams), 0)
            local expectedPattern = Pure("gabba")
            local expectedPattern2 = Pure("bd")
            local _ = P(1, expectedPattern)
            local pattern = P(1, expectedPattern2)
            assert.are.equal(TableSize(Streams), 1)
            assert.are.equal(Streams[1]._pattern, expectedPattern2)
            assert.are.equal(expectedPattern2, pattern)
        end
    )
end
)
