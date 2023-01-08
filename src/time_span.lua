require("math")
require("table")
require('src/fraction')

-- """Returns the start of the cycle."""
-- Fraction.sam = lambda self: Fraction(math.floor(self))

-- """Returns the start of the next cycle."""
-- Fraction.next_sam = lambda self: self.sam() + 1

-- """Returns a TimeSpan representing the begin and end of the Time value's cycle"""
-- Fraction.whole_cycle = lambda self: TimeSpan(self.sam(), self.next_sam())

TimeSpan = {_begin=Fraction:new(1,1), _end=Fraction:new(1,1)}

function TimeSpan:sam(frac)
    return Fraction:new(frac:floor())
end

function TimeSpan:nextSam(frac)
    return Fraction:new(frac:floor()+1)
end

function TimeSpan:wholeCycle(frac)
    return TimeSpan:new(TimeSpan:sam(frac), TimeSpan:nextSam(frac))
end

function TimeSpan:cyclePos(frac)
    return frac - TimeSpan:sam(frac)
end

function TimeSpan:create (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TimeSpan:new(_begin, _end)
    return TimeSpan:create{_begin=_begin, _end=_end}
end

function TimeSpan:beginTime()
    return self._begin
end

function TimeSpan:endTime()
    return self._end
end

function TimeSpan:spanCycles()
    local spans = {}
    local _begin = self._begin
    local _end = self._end
    local end_sam = TimeSpan:sam(_end)

    if _begin == _end then
        return {TimeSpan:new(_begin, _end)}
    end

    while _end > _begin do
        if TimeSpan:sam(_begin) == end_sam then
            table.insert(spans, TimeSpan:new(_begin, self._end))
            break
        end

        local next_begin = TimeSpan:nextSam(_begin)
        table.insert(spans, TimeSpan:new(_begin, next_begin))

        _begin = next_begin
    end
    return spans
end

function TimeSpan:duration()
    return self:endTime() - self:beginTime()
end

function TimeSpan:midpoint()
    return self:beginTime() + (self:duration()/Fraction:new(2,1))
end

function TimeSpan:cycleArc()
    local b = TimeSpan:cyclePos(self:beginTime())
    local e = b + self:duration()
    return TimeSpan:new(b,e)
end

