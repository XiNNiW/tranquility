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
require("tranquility/stream_target")
require("tranquility/pattern")
local losc = require('losc')
local plugin = require('losc.plugins.udp-socket')

Stream = {
    target = StreamTarget:new(),
    _osc = losc.new { plugin = plugin.new { sendAddr = StreamTarget.address, sendPort = StreamTarget.port } },
    _isPlaying = false,
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

function Stream:notifyTick(cycle, s, cps, bpc, mill, now)
    if ((not self._isPlaying) or (not self.pattern)) then
        return
    end
    local cycleFrom = cycle:beginTime()
    local cycleTo = cycle:endTime()

end

-- Create a message
--local message = osc.new_message {
--  address = '/foo/bar',
--  types = 'ifsb',
--  123, 1.234, 'hi', 'blobdata'
--}

-- Send it over UDP


function FirstOsc()
    local p = Pure("bd")
    local events = p:query(State:new(TimeSpan:new(Fraction:new(0, 1), Fraction:new(0, 1)), {}))
    for _, e in pairs(events) do
        local message = losc.new { plugin = plugin.new { sendAddr = StreamTarget.address, sendPort = StreamTarget.port } }
            .new_message {
                address = '/test/addr',
                types = 's',
                e:value()
            }
        losc.new { plugin = plugin.new { sendAddr = StreamTarget.address, sendPort = StreamTarget.port } }:send(message)
    end
    return 2
end
