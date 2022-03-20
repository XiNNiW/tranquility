require('math')

-- this is a quick and dirty port of python's Fraction library pulling in only the things i need to get a first version working
-- this should probably all be C calls instead
--TODO
-- from_float
-- from_decimal
-- mod
-- pow
-- rpow
-- pos
-- neg
-- abs?
-- trunc?
-- floor?
-- ciel?
-- round?

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

function Fraction:__add (f2)

    -- """a + b"""
    -- na, da = a.numerator, a.denominator
    -- nb, db = b.numerator, b.denominator
    -- g = math.gcd(da, db)
    -- if g == 1:
    --     return Fraction(na * db + da * nb, da * db, _normalize=False)
    -- s = da // g
    -- t = na * (db // g) + nb * s
    -- g2 = math.gcd(t, g)
    -- if g2 == 1:
    --     return Fraction(t, s * db, _normalize=False)
    -- return Fraction(t // g2, s * (db // g2), _normalize=False)

    local na = self:numerator()
    local nb = f2:numerator()
    local da = self:denominator()
    local db = f2:denominator()
    local g = gcd(da,db)

    if g == 1 then
        return Fraction:new(na*db + da*nb, da*db, false)
    end
    local s = da//g
    local t = na*(db//g) + nb*s
    local g2 = gcd(t,g)
    if g2 == 1 then
        return Fraction:new(t, s*db, false)
    end
    return Fraction:new(t//g2, s*(db//g2), false)
end

function Fraction:__sub (f2)
    -- """a - b"""
    --     na, da = a.numerator, a.denominator
    --     nb, db = b.numerator, b.denominator
    --     g = math.gcd(da, db)
    --     if g == 1:
    --         return Fraction(na * db - da * nb, da * db, _normalize=False)
    --     s = da // g
    --     t = na * (db // g) - nb * s
    --     g2 = math.gcd(t, g)
    --     if g2 == 1:
    --         return Fraction(t, s * db, _normalize=False)
    --     return Fraction(t // g2, s * (db // g2), _normalize=False)
    local na = self:numerator()
    local nb = f2:numerator()
    local da = self:denominator()
    local db = f2:denominator()
    local g = gcd(da,db)

    if g == 1 then
        return Fraction:new(na*db - da*nb, da*db, false)
    end
    local s = da//g
    local t = na*(db//g) - nb*s
    local g2 = gcd(t,g)
    if g2 == 1 then
        return Fraction:new(t, s*db, false)
    end
    return Fraction:new(t//g2, s*(db//g2), false)

end

function Fraction:__div (f2)
    -- # Same as _mul(), with inversed b.
    -- na, da = a.numerator, a.denominator
    -- nb, db = b.numerator, b.denominator
    -- g1 = math.gcd(na, nb)
    -- if g1 > 1:
    --     na //= g1
    --     nb //= g1
    -- g2 = math.gcd(db, da)
    -- if g2 > 1:
    --     da //= g2
    --     db //= g2
    -- n, d = na * db, nb * da
    -- if d < 0:
    --     n, d = -n, -d
    -- return Fraction(n, d, _normalize=False)
    local na = self:numerator()
    local nb = f2:numerator()
    local da = self:denominator()
    local db = f2:denominator()
    local g1 = gcd(na,nb)
    if g1 > 1 then
        na = na//g1
        nb = nb//g1
    end
    local g2 = gcd(db, da)
    if g2 > 1 then
        da = da//g2
        db = db//g2
    end
    local n = na*db
    local d = nb*da
    if d < 0 then
        n = -n
        d = -d
    end

    return Fraction:new(n,d,false)
end

function Fraction:__mul (f2)
    -- """a * b"""
    -- na, da = a.numerator, a.denominator
    -- nb, db = b.numerator, b.denominator
    -- g1 = math.gcd(na, db)
    -- if g1 > 1:
    --     na //= g1
    --     db //= g1
    -- g2 = math.gcd(nb, da)
    -- if g2 > 1:
    --     nb //= g2
    --     da //= g2
    -- return Fraction(na * nb, db * da, _normalize=False)
    local na = self:numerator()
    local nb = f2:numerator()
    local da = self:denominator()
    local db = f2:denominator()
    local g1 = gcd(na,db)
    if g1 > 1 then
        na = na//g1
        db = db//g1
    end
    local g2 = gcd(nb,da)
    if g2 > 1 then
        nb = nb//g2
        da = da//g2
    end

    return Fraction:new(na*nb,da*db,false)
end