
local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/map')

describe("Map", function()
    it("should map function over collection returning new colleciton",
        function()
            local list = { 1, 2, 3 }
            local add1 = function(v)
                return v + 1
            end
            assert.are.same(Map(add1, list), { 2, 3, 4 })
        end)
end)
