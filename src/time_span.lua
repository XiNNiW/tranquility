require("math")
require('src/fractional')

-- """Returns the start of the cycle."""
-- Fraction.sam = lambda self: Fraction(math.floor(self))

-- """Returns the start of the next cycle."""
-- Fraction.next_sam = lambda self: self.sam() + 1

-- """Returns a TimeSpan representing the begin and end of the Time value's cycle"""
-- Fraction.whole_cycle = lambda self: TimeSpan(self.sam(), self.next_sam())

TimeSpan = {_begin=Fraction:new(1,1),_end=Fraction:new(1,1)}

function TimeSpan:sam(frac)
    return Fraction:new(frac:floor())
end

function TimeSpan:nextSam(frac)
    return Fraction:new(frac:floor()+1)
end

function TimeSpan:create (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TimeSpan:wholeCycle()
    return TimeSpan:new(TimeSpan:sam(self:beginTime()), TimeSpan:nextSam(self:endTime()))
end

function TimeSpan:beginTime ()
    return self._begin
end

function TimeSpan:endTime ()
    return self._end
end

--function TimeSpan.span_cycles()
--    local spans = {}
--    local _begin = self._begin
--    local _end = self._end
--    local end_sam = _end.sam()
--
--    while _end > _begin do
--        if begin.sam() == end_sam then
--            spans.
--        end
--    end
--    return spans
--end
