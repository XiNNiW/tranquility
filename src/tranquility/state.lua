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
require("math")
require("table")
require('tranquility/time_span')
require('tranquility/compare_tables')

State = { _span = TimeSpan:new(), _controls = {} }

function State:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function State:span()
    return self._span
end

function State:new(span, controls)
    return State:create { _span = span, _controls = controls }
end

function State:type()
    return "tranquility.State"
end

function State:setSpan(span)
    return State:new(span, self._controls)
end

function State:withSpan(func)
    return self:setSpan(func(self._span))
end

function State:setControls(controls)
    return State:new(self._span, controls)
end

function State:__eq(other)

    return (self._span == other._span) and CompareTables(self._controls, other._controls)
end
