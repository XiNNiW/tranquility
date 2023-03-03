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
require('tranquility.length')

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
        return Filter(self._query(state), filterFunc)
    end)
end

function Pattern:splitQueries()
    local function query(state)
        return Concat(Map(self._query, state:withSpan(function(span) return span:spanCycles() end)))
    end

    return Pattern:new(query)
end

function Pattern:withQuerySpan(func)
    return Pattern:new(function(state)
        self._query(state:withSpan(func))
    end)
end

function Pattern:withQueryTime(func)
    return Pattern:new(function(state)
        self._query(state:withSpan(function(span) return span:withTime(func) end))
    end)
end

function Pattern:withEventTime(func)
    local query = function(state)
        return Map(function(event)
            return event:withSpan(func)
        end, self._query(state))
    end
    return Pattern:new(query)
end

function Pattern:_bindWhole(chooseWhole, func)
    local patVal = self
    local query = function(state)
        local withWhole = function(a, b)
            return Event:new(chooseWhole(a:whole(), b:part()), b:part(), b:value())
        end

        local match = function(a)
            return Map(
                function(b)
                    withWhole(a, b)
                end,
                func(a:value()):query(state:setSpan(a:part()))
            )
        end

        return Concat(Map(match, patVal:query(state)))
    end
    return Pattern:new(query)
end

function Pattern:outerBind(func)
    local wholeFunc = function(_, b)
        return b
    end
    return self:_bindWhole(wholeFunc, func)
end

function Pattern:outerJoin()
    return self:outerBind(function(thing)
        return thing
    end)
end

function Pattern:_patternify(method)
    local patterned = function(args)
        local patArg = Sequence(args)
        print("patternify1")
        print(Dump(args))
        print(Dump(patArg:queryArc(Fraction:new(0), Fraction:new(1))))
        return patArg:fmap(function(arg)
            print("_patternify")
            print(Dump(arg))
            return method(arg)
        end):outerJoin()
    end
    return patterned
end

function Pattern:withValue(func)
    local query = function(state)
        -- local mapped = {}
        -- local events = self:query(state)
        -- for _, e in pairs(events) do
        --     table.insert(mapped, e:withValue(func))
        -- end
        -- return mapped

        return Map(function(e)
            print("withValue")
            print(Dump(e))
            return e:withValue(func)
        end, self:query(state))
    end
    return Pattern:new(query)
end

function Pattern:fmap(func)
    return self:withValue(func)
end

function Pattern:_fast(value)
    print("_fast")
    print(Dump(value))
    local fastQuery = self:withQueryTime(function(t)
        return t * value
    end)
    local fastEvents = fastQuery:withEventTime(function(t)
        return t / value
    end)
    return fastEvents
end

Pattern.fast = Pattern:_patternify(function(val)
    print("patternified fast")
    print(val)
    return Pattern:_fast(val)
end)

function Pure(value)
    local query = function(state)
        return Map(
            function(subspan)
                local whole = TimeSpan:wholeCycle(subspan:beginTime())
                return Event:new(whole, subspan, value, {}, false)
            end,
            state:span():spanCycles()
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
    if type(pat) ~= "Pattern" then
        return Pure(pat)
    end
    return pat
end

function Slowcat(pats)
    pats = Map(Reify, pats)
    local function query(state)
        local numPats = Length(pats)
        local pat = pats[math.floor(state:span():beginTime()) % numPats]
        return pat:query(state)
    end

    return Pattern:new(query):splitQueries()
end

function Fastcat(pats)
    return Slowcat(pats):_fast(Length(pats))
end

local function _sequenceCount(x)
    if type(x) == "table" then
        if Length(x) == 1 then
            return _sequenceCount(x[1])
        else
            local pats = Map(Sequence, x)
            return table.pack(Fastcat(pats), Length(x))
        end

    elseif type(x) == "Pattern" then
        return table.pack(x, 1)
    else
        return table.pack(Pure(x), 1)
    end
end

function Sequence(x)
    return _sequenceCount(x)[1]
end
