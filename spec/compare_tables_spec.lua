local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/compare_tables')

describe("CompareTables", function()
    it("should deeply compare table values", function()
        local table1 = { first = "red fish", second = { low = 5 } }
        local table2 = { first = "red fish", second = { low = 5 } }
        local table3 = { first = "blue fish", second = { low = 5 } }
        local table4 = { first = "red fish", second = { low = 6 } }
        local table5 = {}
        local table6 = {}
        assert.is_true(CompareTables(table1, table2))
        assert.is_true(CompareTables(table5, table6))
        assert.is_false(CompareTables(table1, table3))
        assert.is_False(CompareTables(table1, table4))
        assert.is_False(CompareTables(table1, table5))
    end)
end)
