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
]]
--
local busted = require "busted"
local describe = busted.describe
local it = busted.it
local mock = busted.mock
require('tranquility/stream')
require('tranquility/pattern')
require('tranquility/control')
local abletonlink = require("abletonlink")
local losc = require('losc')

describe("Stream", function()
    describe("new", function()
        it("should construct with SuperDirt target", function()
            local stream = Stream:new()
            assert.are.same(stream.target, StreamTarget:new())
            assert.are.equal(stream._isPlaying, false)
            assert.are.equal(stream._latency, 0.2)
            assert.is_nil(stream._pattern)
        end)

        it("should have a function declaring its type", function()
            local stream = Stream:new()
            assert.are.equal("tranquility.Stream", stream:type())
        end)
    end)

    describe("notifyTick", function()
        it("should send osc message when called", function()
            local stream = Stream:new()
            stream._osc = mock(losc.new, true)
            stream._osc.new_message = busted.spy()
            stream._osc.send = busted.spy()
            stream._pattern = S("bd")
            local session_state = abletonlink.create_session_state()
            stream:notifyTick(0, 1, session_state, 0.5, 4, 10000, 333)

            assert.spy(stream._osc.new_message).was_called()
            assert.spy(stream._osc.send).was_called()
        end)
    end)
end)
