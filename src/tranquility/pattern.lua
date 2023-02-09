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
require('tranquility.time_span')
require('tranquility.state')
require('tranquility.map')
require('tranquility.filter')

Pattern = { _query = function(_) return {} end }

function Pattern:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Pattern:new(query)
    return Pattern:create { _query = query }
end

function Pattern:query(state)
    return self._query(state)
end

function Pattern:queryArc(beginTime, endTime)
    local span = TimeSpan:new(beginTime, endTime)
    local state = State:new(span)
    return self._query(state)
end

function Pattern:onsetsOnly()
    return self:filterEvents(function(event)
        return event:hasOnset()
    end)
end

function Pattern:filterEvents(filterFunc)
    return Pattern:new(function(state)
        return Filter(self:query(state), filterFunc)
    end)
end

function Pattern:withValue(func)
    local query = function(state)
        local mapped = {}
        local events = self:query(state)
        for _, e in pairs(events) do
            table.insert(mapped, e:withValue(func))
        end
        return mapped
    end
    return Pattern:new(query)
end

function Pattern:fmap(func)
    return self:withValue(func)
end

function Pure(value)
    local query = function(state)
        return Map(
            function(subspan)
                local whole = TimeSpan:wholeCycle(subspan:beginTime())
                return Event:new(whole, subspan, value)
            end,
            state:span():spanCycles()
        )
    end
    return Pattern:new(query)
end

function _sequenceCount(x)
    -- TODO: needs to handle lists!
    if type(x) == "Pattern" then
        return table.pack(x, 1)
    else
        return table.pack(Pure(x), 1)
    end
end

function Sequence(x)
    return _sequenceCount(x)[1]
end
