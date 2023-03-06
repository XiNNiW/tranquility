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

StreamTarget = { name = "SuperDirt", address = "127.0.0.1", port = 57120, latency = 0.2, handshake = true };

function StreamTarget:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function StreamTarget:new(target)
    return StreamTarget:create(target)
end

function StreamTarget:type()
    return "tranquility.StreamTarget"
end
