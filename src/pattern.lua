require("math")

Fraction = {_sign=1,_numerator=1,_denominator=1}

function Fraction:new(numerator,denominator)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o._sign = numerator / math.abs(numerator)
    o._numerator = numerator
    o._denominator = denominator
    return o
end

function Fraction.sam() 
    return Fraction.new(math.floor(self.numerator/self.denominator))
end

function Fraction.next_sam()
    return self.sam() + 1
end

function Fraction.whole_cycle()
    return TimeSpan:new(self.sam(), self.next_sam())
end

TimeSpan = {_begin=Fraction:new(1,1),_end=Fraction:new(1,1)}

function TimeSpan:new(tbegin, tend)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o._begin = tbegin
    o._end = tend 
    return o
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

Pattern = {_query=function(t)end}

function Pattern:new(query)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o._query = query
    return o
end

function Pattern.split_queries()

end
