--[[
Copyright (C) 2023 David Minnix

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more detailself._linkSessionState:

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]] --
require("table")
require("coroutine")
require("tranquility.list")
local socket = require("socket")
local abletonlink = require("abletonlink")

function Sleep(sec)
    socket.sleep(sec)
end

LinkClock = {
    bpm = 120,
    sampleRate = 1 / 20,
    beatsPerCycle = 4,
    _subscribers = List:new(),
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
    local link = abletonlink.create(bpm)
    local session_state = abletonlink.create_session_state()
    return LinkClock:create {
        bpm = bpm, sampleRate = sampleRate, beatsPerCycle = beatsPerCycle,
        _link = link, _linkSessionState = session_state, _subscribers = List:new({})
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
    print("Stop was called")
    coroutine.close(self._notifyCoroutine)
end

function LinkClock:subscribe(subscriber)
    self._subscribers:insert(subscriber)
end

function LinkClock:unsubscribe(subscriber)
    local positionOfSubscriber = false;
    self._subscribers:foreach(function(i, sub)
        if sub == subscriber then
            positionOfSubscriber = i;
        end
    end)
    if positionOfSubscriber then
        self._subscribers:remove(positionOfSubscriber)
    end
end

function LinkClock:createNotifyCoroutine()
    self._notifyCoroutine = coroutine.create(function()
        print("setup", self._isRunning)

        self._link:enable(true)
        self._link:enable_start_stop_sync(true)

        local start = self._link:clock_micros()

        local ticks = 0
        local mill = 1000000
        local frame = self.sampleRate * mill

        print("OK...")

        while self._isRunning do
            print("tick")
            ticks = ticks + 1

            local logicalNow = math.floor(start + (ticks * frame))
            local logicalNext = math.floor(start + ((ticks + 1) * frame))
            local now = self._link:clock_micros()

            local wait = (logicalNow - now) / mill
            if wait > 0 then
                Sleep(wait)
                -- coroutine.yield()
            end

            print("running is set to... ", self._isRunning)

            if not self._isRunning then break end

            self._link:capture_audio_session_state(self._linkSessionState)
            local secondsPerMinute = 60
            local cps = (self._linkSessionState:tempo() / self.beatsPerCycle) / secondsPerMinute
            local cycleFrom = self._linkSessionState:beat_at_time(logicalNow, 0) / self.beatsPerCycle
            local cycleTo = self._linkSessionState:beat_at_time(logicalNext, 0) / self.beatsPerCycle

            self._subscribers:foreach(function(_, sub)
                sub:notifyTick(cycleFrom, cycleTo, self._linkSessionState, cps, self.beatsPerCycle, mill, now)
            end)
            print("the coroutine is running? ... ", coroutine.running())
            coroutine.yield()
        end

        self._linkEnabled = false
    end)
end
