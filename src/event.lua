Event = {
    _whole=TimeSpan:new(),
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
    if self._whole==nil then
        return self._part
    end
    return self._whole
end

function Event:withSpan(func)
    return Event:new(self._whole, func(self._part), self._value, self._context, self._stateful)
end

function Event:withValue(func)
    return Event:new(self._whole, self._part, func(self._value), self._context, self._stateful)
end

function Event:hasOnset()
    return (self._whole ~= nil) and (self._whole:beginTime()==self._part:beginTime())
end
