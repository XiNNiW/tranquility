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

function TestFractional__create()
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

end

function TestFractional__add()
    local f1 = Fraction:new(1,2)
    local f2 = Fraction:new(1,2)
    lu.assertEquals(f1+f2, Fraction:new(1))
end

os.exit( lu.LuaUnit.run() )
