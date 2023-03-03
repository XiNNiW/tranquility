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
require('math')
require("tranquility.dump")
-- this is a quick and dirty port of python's Fraction library pulling in only the things i need to get a first version working
-- this should probably all be C calls instead
--TODO
-- from_float
-- from_decimal
-- eq
-- lt
-- gt
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
    return (b == 0) and a or gcd(b, a % b)
end

local function decimalToFraction(x0, err)
    err = err or 0.0000000001
    local num, den
    local g = math.abs(x0)
    local sign = x0 / g
    local a = 0
    local b = 1
    local c = 1
    local d = 0
    local s
    local iter = 0;
    while iter < 1000000 do

        s = math.floor(g);
        num = a + s * c;
        den = b + s * d;
        a = c;
        b = d;
        c = num;
        d = den;
        g = 1.0 / (g - s);
        iter = iter + 1
        if (err > math.abs(sign * num / den - x0)) then return sign * num, den end
    end
    error("failed to find a fraction for " .. x0)
    return 0, 1;
end

Fraction = { _numerator = 0, _denominator = 1 }

function Fraction:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Fraction:asFloat()
    return self._numerator / self._denominator
end

function Fraction:new(
    numerator,
    denominator,
    shouldNormalize
)
    local n = numerator or 0
    local d = denominator or 1
    if (n % 1) ~= 0 then n, d = decimalToFraction(n) end
    if d == 0 then error("Fractional: divide by zero") end
    local normalize = shouldNormalize or true
    -- n = math.floor(n)
    -- d = math.floor(d)
    if normalize and (n ~= 0) then
        local g = math.floor(gcd(n, d))
        n = n // g
        d = d // g
    end

    local f = Fraction:create { _numerator = n, _denominator = d }
    return f
end

function Fraction:numerator()
    return self._numerator
end

function Fraction:denominator()
    return self._denominator
end

function Fraction:__add(f2)

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
    local g = gcd(da, db)

    if g == 1 then
        return Fraction:new(na * db + da * nb, da * db, false)
    end
    local s = da // g
    local t = na * (db // g) + nb * s
    local g2 = gcd(t, g)
    if g2 == 1 then
        return Fraction:new(t, s * db, false)
    end
    return Fraction:new(t // g2, s * (db // g2), false)
end

function Fraction:__sub(f2)
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
    local g = gcd(da, db)

    if g == 1 then
        return Fraction:new(na * db - da * nb, da * db, false)
    end
    local s = da // g
    local t = na * (db // g) - nb * s
    local g2 = gcd(t, g)
    if g2 == 1 then
        return Fraction:new(t, s * db, false)
    end
    return Fraction:new(t // g2, s * (db // g2), false)

end

function Fraction:__div(f2)
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
    local g1 = gcd(na, nb)
    if g1 > 1 then
        na = na // g1
        nb = nb // g1
    end
    local g2 = gcd(db, da)
    if g2 > 1 then
        da = da // g2
        db = db // g2
    end
    local n = na * db
    local d = nb * da
    if d < 0 then
        n = -n
        d = -d
    end

    return Fraction:new(n, d, false)
end

function Fraction:__mul(f2)
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
    print(Dump(f2))
    if type(f2) == "number" then
        f2 = Fraction:new(f2)
    end
    local na = self:numerator()
    local nb = f2:numerator()
    local da = self:denominator()
    local db = f2:denominator()
    local g1 = gcd(na, db)
    if g1 > 1 then
        na = na // g1
        db = db // g1
    end
    local g2 = gcd(nb, da)
    if g2 > 1 then
        nb = nb // g2
        da = da // g2
    end

    return Fraction:new(na * nb, da * db, false)
end

function Fraction:__pow(f2)
    -- """a ** b
    -- If b is not an integer, the result will be a float or complex
    -- since roots are generally irrational. If b is an integer, the
    -- result will be rational.
    -- """
    -- if isinstance(b, numbers.Rational):
    --     if b.denominator == 1:
    --         power = b.numerator
    --         if power >= 0:
    --             return Fraction(a._numerator ** power,
    --                             a._denominator ** power,
    --                             _normalize=False)
    --         elif a._numerator >= 0:
    --             return Fraction(a._denominator ** -power,
    --                             a._numerator ** -power,
    --                             _normalize=False)
    --         else:
    --             return Fraction((-a._denominator) ** -power,
    --                             (-a._numerator) ** -power,
    --                             _normalize=False)
    --     else:
    --         # A fractional power will generally produce an
    --         # irrational number.
    --         return float(a) ** float(b)
    -- else:
    --     return float(a) ** b
    if f2:denominator() == 1 then
        local power = f2:numerator()
        if power >= 0 then
            return Fraction:new(self:numerator() ^ power, self:denominator() ^ power, false)
        elseif self:numerator() >= 0 then
            return Fraction:new(self:denominator() ^ -power, self:numerator() ^ -power, false)
        else
            return Fraction:new((-self:numerator()) ^ -power, (-self:denominator()) ^ -power, false)
        end
    else
        return (self:numerator() / self:denominator()) ^ (f2:numerator() / f2:denominator())
    end
end

function Fraction:__mod(f2)
    -- """a % b"""
    -- da, db = a.denominator, b.denominator
    -- return Fraction((a.numerator * db) % (b.numerator * da), da * db)
    local da = self:denominator()
    local db = f2:denominator()

    return Fraction:new((self:numerator() * db) % (f2:numerator() * da), da * db)
end

function Fraction:__unm()
    return Fraction:new(-self:numerator(), self:denominator(), false)
end

function Fraction:__eq(rhs)
    return (self:numerator() / self:denominator()) == (rhs:numerator() / rhs:denominator())
end

function Fraction:__lt(rhs)
    return (self:numerator() / self:denominator()) < (rhs:numerator() / rhs:denominator())
end

function Fraction:__lte(rhs)
    return (self:numerator() / self:denominator()) <= (rhs.numerator() / rhs.denominator())
end

function Fraction:floor()
    return self:numerator() // self:denominator()
end

function Fraction:min(other)
    if self < other then
        return self
    else
        return other
    end
end

function Fraction:max(other)
    if self > other then
        return self
    else
        return other
    end
end

function Fraction:show()
    return string.format('%d/%d', self:numerator(), self:denominator())
end
