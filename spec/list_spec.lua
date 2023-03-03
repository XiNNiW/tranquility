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

describe("List", function()
    it("should construct a list", function()
        local list = List:new({ 1, 2, 3 })
        assert.are.equal(1, list[1])
        assert.are.equal(2, list[2])
        assert.are.equal(3, list[3])
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
        assert.are.equal(2, list[1])
        assert.are.equal(4, list[2])
        assert.are.equal(6, list[3])
    end)
    it("should return length", function()

        local list = List:new({ 1, 2, 3 })
        assert.are.equal(list:length(), 3)
    end)
end)
