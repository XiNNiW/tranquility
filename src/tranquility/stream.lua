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
require("os")
local losc = require('losc')
local bundle = require('losc.bundle')
local plugin = require('losc.plugins.udp-socket')
require("tranquility.stream_target")
require("tranquility.dump")



Stream = {
    target = StreamTarget:new(),
    _osc = losc.new { plugin = plugin.new { sendAddr = StreamTarget.address, sendPort = StreamTarget.port } },
    _isPlaying = false,
    _latency = 0.2,
    _pattern = nil
}

function Stream:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Stream:new(target)
    target = target or StreamTarget:new()
    return Stream:create {
        target = target,
        _osc = losc.new { plugin = plugin.new { sendAddr = target.address, sendPort = target.port } }
    }
end

function Stream:type()
    return "tranquility.Stream"
end

function Stream:notifyTick(cycleFrom, cycleTo, s, cps, bpc, mill, now)
    if ((not self._pattern)) then
        return
    end
    local events = self._pattern:onsetsOnly():queryArc(
        Fraction:new(cycleFrom),
        Fraction:new(cycleTo)
    )
    print("cycle from: ", cycleFrom, " ", "cycle to: ", cycleTo)

    events:foreach(function(_, ev)
        local cycleOn = ev:whole():beginTime()
        local cycleOff = ev:whole():endTime()
        local linkOn = s:time_at_beat(cycleOn:asFloat() * bpc, 0)
        local linkOff = s:time_at_beat(cycleOff:asFloat() * bpc, 0)
        local deltaSeconds = (linkOff - linkOn) / mill
        local linkSecs = now / mill
        local libloDiff = losc:now() + (-linkSecs)
        local ts = libloDiff + self._latency + (linkOn / mill)

        local v = ev:value()
        v["cps"] = cps
        v["cycle"] = cycleOn:asFloat()
        v["delta"] = deltaSeconds

        local msg = {}
        for key, value in pairs(v) do
            table.insert(msg, key)
            table.insert(msg, value)
        end
        print("send", Dump(v))
        msg["types"] = GenerateTypesString(msg)
        msg["address"] = '/dirt/play'
        --local b = self._osc.new_bundle(ts, msg)
        --local b = self._osc.new_bundle(ts, self._osc.new_message(msg))
        local b = self._osc.new_message(msg)
        --bundle.validate(b)
        print(Dump(b))
        self._osc:send(b)
    end)
end

function GenerateTypesString(msg)
    local types = ""
    for _, x in pairs(msg) do
        local typeMap = {
            ["table"] = "b",
            ["number"] = "f",
            ["string"] = "s",
        }
        if typeMap[type(x)] then
            types = types .. typeMap[type(x)]
        else
            types = types .. "b"
        end
    end

    return types
end
