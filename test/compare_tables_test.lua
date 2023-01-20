---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/state')

function TestCompareTables()
    local table1 = {first="red fish", second = {low = 5}}
    local table2 = {first="red fish", second = {low = 5}}
    local table3 = {first="blue fish",second = {low = 5}}
    local table4 = {first="red fish", second = {low = 6}}
    local table5 = {}
    local table6 = {}
    lu.assertTrue(CompareTables(table1,table2))
    lu.assertTrue(CompareTables(table5,table6))
    lu.assertFalse(CompareTables(table1,table3))
    lu.assertFalse(CompareTables(table1,table4))
    lu.assertFalse(CompareTables(table1,table5))
end
