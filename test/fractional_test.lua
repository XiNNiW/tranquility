---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/fractional')

function TestFractional__create()
    local f = Fraction:create()
    lu.assertEquals(f:numerator(), 0)
    lu.assertEquals(f:denominator(), 1)
    f = Fraction:create{_numerator=1, _denominator=2}
    lu.assertEquals(f:numerator(), 1)
    lu.assertEquals(f:denominator(), 2)
end

function CreateFraction(n,d) return Fraction:new(n,d) end

function TestFractional__new()
    local f = Fraction:new()
    lu.assertEquals(f:numerator(), 0)
    lu.assertEquals(f:denominator(), 1)
    f = Fraction:new(3,4)
    lu.assertEquals(f:numerator(), 3)
    lu.assertEquals(f:denominator(), 4)
    f = Fraction:new(6,8)
    lu.assertEquals(f:numerator(), 3)
    lu.assertEquals(f:denominator(), 4)
    f = Fraction:new(-4,8)
    lu.assertEquals(f:numerator(), -1)
    lu.assertEquals(f:denominator(), 2)
    f = Fraction:new(4,-8)
    lu.assertEquals(f:numerator(), -1)
    lu.assertEquals(f:denominator(), 2)
    f = Fraction:new(-4,-8)
    lu.assertEquals(f:numerator(), 1)
    lu.assertEquals(f:denominator(), 2)
    lu.assertError(CreateFraction, 1, 0)
end

function TestFractional__add()
    local f1 = Fraction:new(1,2)
    local f2 = Fraction:new(1,2)
    lu.assertEquals(f1+f2, Fraction:new(1))
    f1 = Fraction:new(1,2)
    f2 = Fraction:new(1,3)
    -- 3/6 + 2/6
    lu.assertEquals(f1+f2, Fraction:new(5,6))
    f1 = Fraction:new(1,2)
    f2 = Fraction:new(-1,3)
    -- 3/6 + -2/6
    lu.assertEquals(f1+f2, Fraction:new(1,6))
end

function TestFractional__sub()
    local f1 = Fraction:new(1,2)
    local f2 = Fraction:new(1,2)
    lu.assertEquals(f1-f2, Fraction:new(0))
    f1 = Fraction:new(1,2)
    f2 = Fraction:new(1,3)
    -- 3/6 - 2/6
    lu.assertEquals(f1-f2, Fraction:new(1,6))
    f1 = Fraction:new(1,2)
    f2 = Fraction:new(-1,3)
    -- 3/6 - -2/6
    lu.assertEquals(f1-f2, Fraction:new(5,6))
end

function TestFractional__mult()
    local f1 = Fraction:new(1,2)
    local f2 = Fraction:new(1,2)
    lu.assertEquals(f1*f2, Fraction:new(1,4))
    f1 = Fraction:new(1,2)
    f2 = Fraction:new(1,3)
    lu.assertEquals(f1*f2, Fraction:new(1,6))
    f1 = Fraction:new(1,2)
    f2 = Fraction:new(-1,3)
    lu.assertEquals(f1*f2, Fraction:new(-1,6))
end

function TestFractional__div()
    local f1 = Fraction:new(1,2)
    local f2 = Fraction:new(1,2)
    lu.assertEquals(f1/f2, Fraction:new(1))
    f1 = Fraction:new(1,2)
    f2 = Fraction:new(1,3)
    lu.assertEquals(f1/f2, Fraction:new(3,2))
    f1 = Fraction:new(1,2)
    f2 = Fraction:new(-1,3)
    lu.assertEquals(f1/f2, Fraction:new(-3,2))
end


function TestFractional__mod()
    local f1 = Fraction:new(1,2)
    local f2 = Fraction:new(2,3)
    lu.assertEquals(f1%f2, Fraction:new(1,2))
    f1 = Fraction:new(3,4)
    f2 = Fraction:new(2,3)
    -- 9/12 % 8/12 = 1/12
    lu.assertEquals(f1%f2, Fraction:new(1,12))
    
end

function TestFractional__pow()
    local f1 = Fraction:new(1,4)
    local f2 = Fraction:new(1,2)
    lu.assertEquals(f1^f2, 0.5)
    local f1 = Fraction:new(1,4)
    local f2 = Fraction:new(2,1)
    lu.assertEquals(f1^f2, Fraction:new(1,16))
end

function TestFractional__neg()
    local f1 = Fraction:new(1,4)
    lu.assertEquals(-f1, Fraction:new(-1,4))
end

function TestFractional__floor()
    local f1 = Fraction:new(1,4)
    lu.assertEquals(f1:floor(), 0)
    f1 = Fraction:new(5,4)
    lu.assertEquals(f1:floor(), 1)
    f1 = Fraction:new(9,4)
    lu.assertEquals(f1:floor(), 2)
end


--os.exit( lu.LuaUnit.run() )
