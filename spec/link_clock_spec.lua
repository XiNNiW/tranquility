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
local mock = busted.mock
require('tranquility/link_clock')
require('tranquility/pattern')
require('tranquility/stream')

describe("LinkClock", function()
    describe("construction", function()
        it("should create with defaults", function()
            local clock = LinkClock:new()
            assert.are.equal(clock.bpm, 120)
            assert.are.equal(clock.sampleRate, 1 / 20)
            assert.are.equal(clock.beatsPerCycle, 4)
            assert.are.equal(clock._isRunning, false)
            assert.are.same(clock._subscribers, List:new({}))
            assert.is_not_nil(clock._link)
            assert.is_not_nil(clock._linkSessionState)
            assert.is_nil(clock._notifyCoroutine)
        end)
    end)

    it("should have a function declaring its type", function()
        local clock = LinkClock:new()
        assert.are.equal("tranquility.LinkClock", clock:type())
    end)
    describe("subscribe/unsubscribe", function()
        it("should add/remove to list of subscribers", function()
            local clock = LinkClock:new(120)
            local mySub = Stream:new()
            mySub._pattern = Pure("i am the first")
            clock:subscribe(mySub)
            assert.are.equal(clock._subscribers:length(), 1)
            assert.are.equal(clock._subscribers:at(1), mySub) -- lua is 1 indexed... i will remember... lol
            local mySub2 = Stream:new()
            mySub2._pattern = Pure("I am the second")
            clock:subscribe(mySub2)
            assert.are.equal(clock._subscribers:length(), 2)
            assert.are.equal(clock._subscribers:at(1), mySub)
            assert.are.equal(clock._subscribers:at(2), mySub2)
            clock:unsubscribe(mySub)
            assert.are.equal(clock._subscribers:length(), 1)
            assert.are.equal(clock._subscribers:at(1), mySub2)
        end)
    end)
    describe("notify", function()
        it("should call stream's notify method on tick", function()
            local clock = LinkClock:new()
            clock._link = mock(clock._link, true)
            clock._linkSessionState = mock(clock._linkSessionState)
            local stream = mock(Stream:new(), true)
            clock:subscribe(stream)
            clock:start()

        end)
    end)
end)
