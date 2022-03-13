require('math')

local function gcd(a, b)
	return b==0 and a or gcd(b,a%b)
end

Fraction = {_numerator=0,_denominator=1}

function Fraction:create (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Fraction:new (
    numerator, 
    denominator, 
    shouldNormalize 
)
    local n = numerator or 0
    local d = denominator or 1
    local normalize = shouldNormalize or true
    n = math.floor(n)
    d = math.floor(d)
    if normalize then
        local g = gcd(n,d)
        n = n//g
        d = d//g
    end
    
    local f = Fraction:create{_numerator = n, _denominator = d}
    return f
end

function Fraction:numerator ()
    return self._numerator
end

function Fraction:denominator ()
    return self._denominator
end

--TODO
-- from_float
-- from_decimal
-- __add
-- __sub
-- __mul
-- __div

function Fraction:__add (f2)
    --n = self:numerator() + f2:numerator()
    --d = self:denominator() + f2:denominator()
    return Fraction:new(3,4)
end

