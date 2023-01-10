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

function Event:new(whole, part, value, context)
    return Event:create{
        _whole=whole,
        _part=part,
        _value=value,
        _context=context
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

function Event:hasOnset()
    return (self._whole ~= nil) and (self._whole:beginTime()==self._part:beginTime())
end
