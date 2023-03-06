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
require('tranquility.fraction')
require('tranquility.list')

TimeSpan = { _begin = Fraction:new(1, 1), _end = Fraction:new(1, 1) }

function TimeSpan:sam(frac)
    return Fraction:new(frac:floor())
end

function TimeSpan:nextSam(frac)
    return Fraction:new(frac:floor() + 1)
end

function TimeSpan:wholeCycle(frac)
    return TimeSpan:new(TimeSpan:sam(frac), TimeSpan:nextSam(frac))
end

function TimeSpan:cyclePos(frac)
    return frac - TimeSpan:sam(frac)
end

function TimeSpan:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TimeSpan:new(_begin, _end)
    if type(_begin) == "number" then
        _begin = Fraction:new(_begin)
    end
    if type(_end) == "number" then
        _end = Fraction:new(_end)
    end
    return TimeSpan:create { _begin = _begin, _end = _end }
end

function TimeSpan:type()
    return "tranquility.TimeSpan"
end

function TimeSpan:beginTime()
    return self._begin
end

function TimeSpan:endTime()
    return self._end
end

function TimeSpan:spanCycles()
    local spans = List:new({})
    local _begin = self._begin
    local _end = self._end
    local end_sam = TimeSpan:sam(_end)

    if _begin == _end then
        return List:new({ TimeSpan:new(_begin, _end) })
    end

    while _end > _begin do
        if TimeSpan:sam(_begin) == end_sam then
            spans:insert(TimeSpan:new(_begin, self._end))
            break
        end

        local next_begin = TimeSpan:nextSam(_begin)
        spans:insert(TimeSpan:new(_begin, next_begin))

        _begin = next_begin
    end
    return spans
end

function TimeSpan:duration()
    return self:endTime() - self:beginTime()
end

function TimeSpan:midpoint()
    return self:beginTime() + (self:duration() / Fraction:new(2, 1))
end

function TimeSpan:cycleArc()
    local b = TimeSpan:cyclePos(self:beginTime())
    local e = b + self:duration()
    return TimeSpan:new(b, e)
end

function TimeSpan:__eq(rhs)
    return (self:beginTime() == rhs:beginTime()) and (self:endTime() == rhs:endTime())
end

function TimeSpan:show()
    return self:__tostring()
end

function TimeSpan:__tostring()
    return string.format('%s → %s', self:beginTime():show(), self:endTime():show())
end

function TimeSpan:withTime(func)
    return TimeSpan:new(func(self:beginTime()), func(self:endTime()))
end

function TimeSpan:withEnd(func)
    return TimeSpan:new(self:beginTime(), func(self:endTime()))
end

function TimeSpan:intersection(other)
    local startOfIntersection = self:beginTime():max(other:beginTime())
    local endOfIntersection = self:endTime():min(other:endTime())

    if startOfIntersection > endOfIntersection then return nil end
    if startOfIntersection == endOfIntersection then
        if (startOfIntersection == self:endTime()) and (self:beginTime() < self:endTime()) then
            return nil
        end
        if (startOfIntersection == other:endTime()) and (other:beginTime() < other:endTime()) then
            return nil
        end
    end
    return TimeSpan:new(startOfIntersection, endOfIntersection)
end

function TimeSpan:intersection_e(other)
    local result = self:intersection(other)
    if result == nil then
        error("TimeSpan: TimeSpans do not intersect")
    end
    return result
end
