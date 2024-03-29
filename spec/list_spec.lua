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
require('tranquility.list')
require('tranquility.dump')

describe("List", function()
    it("should construct a list", function()
        local list = List:new({ 1, 2, 3 })
        assert.are.equal(1, list:at(1))
        assert.are.equal(2, list:at(2))
        assert.are.equal(3, list:at(3))

    end)

    it("should have a function declaring its type", function()
        local list = List:new()
        assert.are.equal("tranquility.List", list:type())
    end)
    it("should iterate", function()
        local list = List:new({ 1, 2, 3 })
        local expectedValues = { 1, 2, 3 }
        list:foreach(function(index, value)
            assert.are.equal(expectedValues[index], value)
        end)
    end)
    it("should map", function()
        local list = List:new({ 1, 2, 3 })
        local mapped = list:map(function(element)
            return element * 2
        end)
        assert.are.equal(2, mapped:at(1))
        assert.are.equal(4, mapped:at(2))
        assert.are.equal(6, mapped:at(3))
    end)
    it("should return length", function()

        local list = List:new({ 1, 2, 3 })
        assert.are.equal(list:length(), 3)
    end)


    it("should concat", function()

        local list1 = List:new({ 1, 2, 3 })
        local list2 = List:new({ 4, 5, 6 })
        local combined = list1:concat(list2)
        assert.are.equal(combined:length(), 6)

        assert.are.equal(1, combined:at(1))
        assert.are.equal(2, combined:at(2))
        assert.are.equal(3, combined:at(3))
        assert.are.equal(4, combined:at(4))
        assert.are.equal(5, combined:at(5))
        assert.are.equal(6, combined:at(6))
    end)

    it("should __concat", function()

        local list1 = List:new({ 1, 2, 3 })
        local list2 = List:new({ 4, 5, 6 })
        local combined = list1 .. list2
        assert.are.equal(combined:length(), 6)

        assert.are.equal(1, combined:at(1))
        assert.are.equal(2, combined:at(2))
        assert.are.equal(3, combined:at(3))
        assert.are.equal(4, combined:at(4))
        assert.are.equal(5, combined:at(5))
        assert.are.equal(6, combined:at(6))
    end)

    it("should return filter", function()
        local list = List:new({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 })
        local expectedFilteredList = List:new({ 1, 3, 5, 7, 9, 11 })
        local filterFunc = function(element)
            return (element % 2) ~= 0
        end
        assert.are.same(list:filter(filterFunc), expectedFilteredList)
    end)

    it("should insert and remove", function()
        local list = List:new({ 1, 2, 3 })
        list:insert(4)
        assert.are.equal(List:new({ 1, 2, 3, 4 }), list)
        list:remove(3)
        assert.are.equal(List:new({ 1, 2, 4 }), list)
    end)

    it("should flatten", function()
        local list = List:new({ 1, 2, 3 })
        local flattened = list:flatten()
        assert.are.equal(list:length(), flattened:length())
        assert.are.equal(list:at(1), flattened:at(1))
        assert.are.equal(list:at(2), flattened:at(2))
        assert.are.equal(list:at(3), flattened:at(3))
        assert.are.same(list, flattened)

        list = List:new({ 1, List:new({ 1, 2, 3 }), 3 })
        flattened = list:flatten()
        local expectedFlatList = List:new({ 1, 1, 2, 3, 3 })
        assert.are.equal(expectedFlatList:length(), flattened:length())
        assert.are.equal(expectedFlatList:at(1), flattened:at(1))
        assert.are.equal(expectedFlatList:at(2), flattened:at(2))
        assert.are.equal(expectedFlatList:at(3), flattened:at(3))
        assert.are.equal(expectedFlatList:at(4), flattened:at(4))
        assert.are.equal(expectedFlatList:at(5), flattened:at(5))
        assert.are.same(expectedFlatList, flattened)
    end)

    it("should __eq", function()
        local list1 = List:new({ 1, 2, 3 })
        local list2 = List:new({ 1, 2, 3 })
        assert.are.equal(list1, list2)
        assert.is_true(list1 == list2)
    end)

    --it("should iterate using pairs", function()
    --    local list = List:new({ 1, 2, 3 })
    --    local list2 = List:new()
    --    for key, value in pairs(list) do
    --        list2:assign(key, value)
    --    end
    --    assert.are.same(list:length(), list2:length())
    --    assert.are.same(list:at(1), list2:at(1))
    --    assert.are.same(list:at(2), list2:at(2))
    --    assert.are.same(list:at(3), list2:at(3))
    --end)
end)
