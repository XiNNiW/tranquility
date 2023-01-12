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
]]--

Event = {
    _whole=nil,
    _part=TimeSpan:new(),
    _value=nil,
    _context = {},
    _stateful= false
}

function Event:create (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Event:new(whole, part, value, context, stateful)
    if(stateful and type(value) ~= "function") then error("Event: stateful event values must be of type function") end
    return Event:create{
        _whole=whole,
        _part=part,
        _value=value,
        _context=context,
        _stateful = stateful
    }
end

function Event:duration()
    return self._whole:endTime() - self._whole:beginTime()
end

function Event:wholeOrPart()
    if self._whole~=nil then
        return self._whole
    end
    return self._part
end

function Event:withSpan(func)
    local whole = self._whole
    if self._whole ~= nil then
        whole = func(self._whole)
    end
    return Event:new(whole, func(self._part), self._value, self._context, self._stateful)
end

function Event:withValue(func)
    return Event:new(self._whole, self._part, func(self._value), self._context, self._stateful)
end

function Event:hasOnset()
    return (self._whole ~= nil) and (self._whole:beginTime()==self._part:beginTime())
end

function Event:spanEquals(other)
    return ((other._whole == nil) and (self._whole == nil)) or (other._whole == self._whole)
end

function Event:__eq(other)
    return
        (self._part==other._part) and
        (self._whole == other._whole) and
        (self._value == other._value) and
        CompareTable(self._context, other._context) and
        (self._stateful == other._stateful)
end

function CompareTable(table1,table2,ignore_mt)
    if type(table1) ~= type(table2) then return false end
    local metatable1 = getmetatable(table1)
    if not ignore_mt and metatable1 and metatable1.__eq then return table1 == table2 end
    for key,value1 in pairs(table1) do
        local value2 = table2[key]
        if value2 == nil or not CompareTable(value1,value2) then return false end
    end
    for key,value2 in pairs(table2) do
        local value1 = table1[key]
        if value1 == nil or not CompareTable(value1,value2) then return false end
    end
    return true
end
