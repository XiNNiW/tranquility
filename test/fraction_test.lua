---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/fraction')

function TestFraction__create()
    local f = Fraction:create()
    lu.assertEquals(f:numerator(), 0)
    lu.assertEquals(f:denominator(), 1)
    f = Fraction:create{_numerator=1, _denominator=2}
    lu.assertEquals(f:numerator(), 1)
    lu.assertEquals(f:denominator(), 2)
end

function CreateFraction(n,d) return Fraction:new(n,d) end

function TestFraction__new()
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
   -- Does Fraction need to reduce decimal numbers to closest approximation?
    --f = Fraction:new(1.5, 7.6)
   -- lu.assertEquals(f:numerator(), 1.5)
   -- lu.assertEquals(f:denominator(), 7.6)
    lu.assertError(CreateFraction, 1, 0)
end

-- Does Fraction need to infer fraction from string representation?
--function TestFractional__new__fromString()
--    local f = Fraction:new("1/2")
--    lu.assertEquals(f:numerator(), 1)
--    lu.assertEquals(f:denominator(), 2)
--end

function TestFraction__add()
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

function TestFraction__sub()
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

function TestFraction__mult()
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

function TestFraction__div()
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


function TestFraction__mod()
    local f1 = Fraction:new(1,2)
    local f2 = Fraction:new(2,3)
    lu.assertEquals(f1%f2, Fraction:new(1,2))
    f1 = Fraction:new(3,4)
    f2 = Fraction:new(2,3)
    -- 9/12 % 8/12 = 1/12
    lu.assertEquals(f1%f2, Fraction:new(1,12))
end

function TestFraction__pow()
    local f1 = Fraction:new(1,4)
    local f2 = Fraction:new(1,2)
    lu.assertEquals(f1^f2, 0.5)
    f1 = Fraction:new(1,4)
    f2 = Fraction:new(2,1)
    lu.assertEquals(f1^f2, Fraction:new(1,16))
end

function TestFraction__neg()
    local f1 = Fraction:new(1,4)
    lu.assertEquals(-f1, Fraction:new(-1,4))
end

function TestFraction__floor()
    local f1 = Fraction:new(1,4)
    lu.assertEquals(f1:floor(), 0)
    f1 = Fraction:new(5,4)
    lu.assertEquals(f1:floor(), 1)
    f1 = Fraction:new(9,4)
    lu.assertEquals(f1:floor(), 2)
end

function TestFraction__gt()
    lu.assertTrue(Fraction:new(3,4) > Fraction:new(1,3))
    lu.assertTrue(Fraction:new(5,4) > Fraction:new(1,1))
    lu.assertFalse(Fraction:new(1,3)> Fraction:new(1,2))
    lu.assertFalse(Fraction:new(5,4)> Fraction:new(7,4))
end

function TestFraction__lt()
    lu.assertTrue(Fraction:new(1,4) < Fraction:new(1,3))
    lu.assertTrue(Fraction:new(1,4) < Fraction:new(1,3))
    lu.assertTrue(Fraction:new(5,4) < Fraction:new(7,3))
    lu.assertFalse(Fraction:new(2,3)< Fraction:new(1,2))
    lu.assertFalse(Fraction:new(9,1)< Fraction:new(7,4))
end

function TestFraction__gte()
    lu.assertTrue(Fraction:new(3,4) >= Fraction:new(1,3))
    lu.assertTrue(Fraction:new(1,3) >= Fraction:new(1,3))
    lu.assertTrue(Fraction:new(-1,3) >= Fraction:new(-7,3))
    lu.assertTrue(Fraction:new(5,4) >= Fraction:new(5,4))
    lu.assertFalse(Fraction:new(1,3)>= Fraction:new(1,2))
    lu.assertFalse(Fraction:new(5,4)>= Fraction:new(7,4))
end

function TestFraction__lte()
    lu.assertTrue(Fraction:new(1,4) <= Fraction:new(1,3))
    lu.assertTrue(Fraction:new(1,4) <= Fraction:new(1,4))
    lu.assertTrue(Fraction:new(5,4) <= Fraction:new(7,3))
    lu.assertTrue(Fraction:new(-5,4) <= Fraction:new(7,3))
    lu.assertFalse(Fraction:new(2,3)<= Fraction:new(1,2))
    lu.assertFalse(Fraction:new(9,1)<= Fraction:new(7,4))
end

function TestFraction__eq()
    lu.assertTrue(Fraction:new(1,4) == Fraction:new(1,4))
    lu.assertTrue(Fraction:new(5,4) == Fraction:new(10,8))
    lu.assertTrue(Fraction:new(-2,3)== Fraction:new(8,-12))
    lu.assertTrue(Fraction:new(-1,3)== Fraction:new(-3,9))
    lu.assertFalse(Fraction:new(254,255) == Fraction:new(255,256))
end

function TestFraction__min()
    lu.assertEquals(Fraction:new(3,4):min(Fraction:new(5,6)), Fraction:new(3,4))
    lu.assertEquals(Fraction:new(3,4):min(Fraction:new(3,6)), Fraction:new(3,6))
    lu.assertEquals(Fraction:new(3,4):min(Fraction:new(-5,6)), Fraction:new(-5,6))
    lu.assertEquals(Fraction:new(-3,4):min(Fraction:new(-5,6)), Fraction:new(-5,6))
end

function TestFraction__max()
    lu.assertEquals(Fraction:new(3,4):max(Fraction:new(5,6)), Fraction:new(5,6))
    lu.assertEquals(Fraction:new(3,4):max(Fraction:new(3,6)), Fraction:new(3,4))
    lu.assertEquals(Fraction:new(3,4):max(Fraction:new(-5,6)), Fraction:new(3,4))
    lu.assertEquals(Fraction:new(-3,4):max(Fraction:new(-5,6)), Fraction:new(-3,4))
end
function TestFraction__show()
    lu.assertEquals(Fraction:new(1,2):show(), "1/2")
end
--os.exit( lu.LuaUnit.run() )
