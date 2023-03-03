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
