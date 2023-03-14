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
require('tranquility.fraction')
require('tranquility.type')

describe("Type", function()
    it("should return the tranquility class type or the value of type operator if not defined", function()
        local hasClassType = Fraction:new()
        local doesNotHaveClassType = { thing = "value" }
        local doesNotHaveClassType2 = 3
        assert.are.equal("tranquility.Fraction", Type(hasClassType))
        assert.are.equal("table", Type(doesNotHaveClassType))
        assert.are.equal("number", Type(doesNotHaveClassType2))
    end)
end)
