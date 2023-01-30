local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/filter')

describe("Filter", function ()
    it("should return new list with elements removed based on whether they pass the filter func", function ()
        local list = {1,2,3,4,5,6,7,8,9,10,11}
        local expectedFilteredList = {1,3,5,7,9,11}
        local filterFunc = function (element)
            return (element%2) ~= 0
        end
        assert.are.same(Filter(list, filterFunc), expectedFilteredList)
    end)
end)
