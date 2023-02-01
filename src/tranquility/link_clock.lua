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
require("table")
require("coroutine")
local socket = require("socket")
local abeltonlink = require("abletonlink")

function Sleep(sec)
    socket.select(nil, nil, sec)
end

LinkClock = {
    bpm = 120,
    sampleRate = 1 / 20,
    beatsPerCycle = 4,
    _subscribers = {},
    _isRunning = false,
    _link = nil,
    _linkSessionState = nil,
    _notifyCoroutine = nil
}

function LinkClock:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function LinkClock:new(bpm, sampleRate, beatsPerCycle)
    bpm = bpm or 120
    sampleRate = sampleRate or (1 / 20)
    beatsPerCycle = beatsPerCycle or 4
    local link = abeltonlink.create(bpm)
    local session_state = abeltonlink.create_session_state()
    return LinkClock:create {
        bpm = bpm, sampleRate = sampleRate, beatsPerCycle = beatsPerCycle,
        _link = link, _link_session_state = session_state
    }
end

function LinkClock:start()
    if not self._isRunning then
        self._isRunning = true
        self:createNotifyCoroutine()
    end
end

function LinkClock:stop()
    self._isRunning = false
    coroutine.close(self._notifyCoroutine)
end

function LinkClock:subscribe(subscriber)
    table.insert(self._subscribers, subscriber)
end

function LinkClock:unsubscribe(subscriber)
    local positionOfSubscriber = false;
    for i, sub in pairs(self._subscribers) do
        if sub == subscriber then
            positionOfSubscriber = i;
        end
    end
    if positionOfSubscriber then
        table.remove(self._subscribers, positionOfSubscriber)
    end
end

function LinkClock:createNotifyCoroutine()
    self._notify_coroutine = coroutine.create(function()
        self:_notifyCoroutineTarget()
    end)
end

function LinkClock:_notifyCoroutineTarget()
    self._link.enabled = true
    self._link.startStopSyncEnabled = true

    local start = self._link.clock().micros()

    local ticks = 0
    local mill = 1000000
    local frame = self.rate * mill

    while self._isRunning do
        ticks = ticks + 1

        local logicalNow = math.floor(start + (ticks * frame))
        local logicalNext = math.floor(start + ((ticks + 1) * frame))
        local now = self._link.clock().micros()

        local wait = (logicalNow - now) / mill
        if wait > 0 then
            Sleep(wait)
        end

        if not self._isRunning then break end

        local s = self._link.captureSessionState()
        local secondsPerMinute = 60
        local cps = (s.tempo() / self.beatsPerCycle) / secondsPerMinute
        local cycleFrom = s.beatAtTime(logicalNow, 0) / self.beatsPerCycle
        local cycleTo = s.beatAtTime(logicalNext, 0) / self.beatsPerCycle

        for _, sub in pairs(self._subscribers) do
            sub.notifyTick(cycleFrom, cycleTo, s, cps, self.beatsPerCycle, mill, now)
        end
        coroutine.yield()
    end

    self._linkEnabled = false

end
