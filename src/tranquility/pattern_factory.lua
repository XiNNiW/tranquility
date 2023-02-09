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
require("tranquility.pattern")
require("tranquility.link_clock")
require("tranquility.stream")

Streams = {}
DefaultClock = LinkClock:new()

function P(key, pattern)
    if not Streams[key] then
        local stream = Stream:new()
        DefaultClock:subscribe(stream)
        Streams[key] = stream

    end
    Streams[key]._pattern = pattern
    return pattern
end

function Hush()
    for _, stream in pairs(Streams) do
        DefaultClock:unsubscribe(stream)
    end
    Streams = {}
end
