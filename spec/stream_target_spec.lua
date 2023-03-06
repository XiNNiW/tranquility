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
require('tranquility/stream_target')

describe("Target", function()
    it("should default to SuperDirt settings", function()
        local target = StreamTarget:new()
        assert.are.equal(target.name, "SuperDirt")
        assert.are.equal(target.address, "127.0.0.1")
        assert.are.equal(target.port, 57120)
        assert.are.equal(target.latency, 0.2)
        assert.is_true(target.handshake)
    end)

    it("should have a function declaring its type", function()
        local streamTarget = StreamTarget:new()
        assert.are.equal("tranquility.StreamTarget", streamTarget:type())
    end)
end)
