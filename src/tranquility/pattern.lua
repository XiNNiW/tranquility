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
require("math")
require('tranquility.state')
require('tranquility.type')
require('tranquility.event')

Pattern = { _query = function(_) return List:new() end }

function Pattern:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Pattern:new(query)
    return Pattern:create { _query = query }
end

function Pattern:type()
    return "tranquility.Pattern"
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
        return self._query(state):filter(filterFunc)
    end)
end

function Pattern:splitQueries()
    local function splitQuery(state)
        return state:span():spanCycles():map(function(subspan)
            return self._query(state:setSpan(subspan))
        end):flatten()
    end

    return Pattern:new(splitQuery)
end

function Pattern:withQuerySpan(func)
    return Pattern:new(function(state)
        return self._query(state:withSpan(func))
    end)
end

function Pattern:withQueryTime(func)
    return Pattern:new(function(state)
        return self._query(state:withSpan(function(span) return span:withTime(func) end))
    end)
end

function Pattern:withEventTime(func)
    local query = function(state)
        return self._query(state):map(function(event)
            return event:withSpan(function(span)
                return span:withTime(func)
            end)
        end)
    end
    return Pattern:new(query)
end

function Pattern:_bindWhole(chooseWhole, func)
    local patVal = self
    local query = function(state)
        local withWhole = function(a, b)
            return Event:new(chooseWhole(a:whole(), b:whole()), b:part(), b:value())
        end

        local match = function(a)
            return func(a:value()):query(state:setSpan(a:part())):map(
                function(b)
                    return withWhole(a, b)
                end
            )
        end

        return patVal:query(state):map(match):flatten()
    end
    return Pattern:new(query)
end

function Pattern:outerBind(func)
    local chooseOuterWhole = function(_, whole)
        return whole
    end
    return self:_bindWhole(chooseOuterWhole, func)
end

function Pattern:outerJoin()
    local function id(x)
        return x
    end

    return self:outerBind(id)
end

function Pattern:_patternify(method)
    local patterned = function(patSelf, ...)
        local patArg = Sequence(List:promote(...))
        print("PAT ARG")
        print(patArg)
        print(patSelf)
        print(List:promote(...))
        print(method)
        return patArg:fmap(function(arg)
            return method(patSelf, arg)
        end):outerJoin()
    end
    return patterned
end

function Pattern:withValue(func)
    local query = function(state)
        return self:query(state):map(function(e)
            return e:withValue(func)
        end)
    end
    return Pattern:new(query)
end

function Pattern:fmap(func)
    return self:withValue(func)
end

function Pattern:_fast(value)
    local fastQuery = self:withQueryTime(function(t)
        return t * value
    end)
    local fastPattern = fastQuery:withEventTime(function(t)
        return t / value
    end)
    return fastPattern
end

function Pattern:_slow(value)
    return self:_fast(1 / value)
end

function Pattern:firstCycle()
    return self:queryArc(0, 1)
end

function Pattern:__tostring()
    return tostring(self:firstCycle())
end

function Pattern:show()
    return self:__tostring()
end

Pattern.fast = Pattern:_patternify(function(patSelf, val)
    return patSelf:_fast(val)
end)

Pattern.slow = Pattern:_patternify(function(patSelf, val)
    return patSelf:_slow(val)
end)

function Pure(value)
    local query = function(state)
        return state:span():spanCycles():map(
            function(subspan)
                local whole = TimeSpan:wholeCycle(subspan:beginTime())
                return Event:new(whole, subspan, value, List:new(), false)
            end
        )
    end
    return Pattern:new(query)
end

--def _sequence_count(x):
--    if type(x) == list or type(x) == tuple:
--        if len(x) == 1:
--            return _sequence_count(x[0])
--        else:
--            return (fastcat(*[sequence(x) for x in x]), len(x))
--    if isinstance(x, Pattern):
--        return (x,1)
--    else:
--        return (pure(x), 1)
function Reify(pat)
    if Type(pat) ~= "tranquility.Pattern" then
        return Pure(pat)
    end
    return pat
end

function Slowcat(pats)
    pats = List:promote(pats)
    pats = pats:map(Reify)
    local function query(state)
        local numPats = pats:length()
        local pat = pats:at((state:span():beginTime():floor() % numPats) + 1)
        return pat._query(state)
    end

    return Pattern:new(query):splitQueries()
end

function Fastcat(pats)
    pats = List:promote(pats)
    return Slowcat(pats):_fast(pats:length())
end

local function _sequenceCount(x)
    if Type(x) == "tranquility.List" then
        if x:length() == 1 then
            return _sequenceCount(x:at(1))
        else
            local pats = x:map(Sequence)
            return Fastcat(pats), x:length()
        end
    elseif Type(x) == "tranquility.Pattern" then
        return x, 1
    else
        return Pure(x), 1
    end
end

function Sequence(x)
    local seq, _ = _sequenceCount(x)
    return seq
end
