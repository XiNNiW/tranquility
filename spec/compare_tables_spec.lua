--[[
Copyright (C) 2023 David Minnix

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]] --
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
