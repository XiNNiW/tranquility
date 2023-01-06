---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/time_span')

function TestTimeSpan_sam()
    local f = Fraction:new(3, 4)
    local sam = TimeSpan:sam(f)
    lu.assertEquals(sam, Fraction:new(0, 1))
    f = Fraction:new(5, 4)
    sam = TimeSpan:sam(f)
    lu.assertEquals(sam, Fraction:new(1, 1))
end

function TestTimeSpan_nextSam()
    local f = Fraction:new(3, 4)
    local sam = TimeSpan:nextSam(f)
    lu.assertEquals(sam, Fraction:new(1, 1))
    f = Fraction:new(5, 4)
    sam = TimeSpan:nextSam(f)
    lu.assertEquals(sam, Fraction:new(2, 1))
end

function TestFractional__wholeCycle()
    local f1 = Fraction:new(1, 2)
    lu.assertEquals(TimeSpan:new(Fraction:new(0, 1), Fraction:new(1, 1)), TimeSpan:wholeCycle(f1))
    f1 = Fraction:new(3, 2)
    lu.assertEquals(TimeSpan:new(Fraction:new(1, 1), Fraction:new(2, 1)), TimeSpan:wholeCycle(f1))
end

function TestTimeSpan__create()
    local ts = TimeSpan:create()
    lu.assertEquals(ts:beginTime(), Fraction:new(1))
    lu.assertEquals(ts:endTime()  , Fraction:new(1))
    ts = TimeSpan:create{}
    lu.assertEquals(ts:beginTime(), Fraction:new(1))
    lu.assertEquals(ts:endTime()  , Fraction:new(1))
end

function TestTimeSpan__new()
    local ts = TimeSpan:new(Fraction:new(3), Fraction:new(4))
    lu.assertEquals(ts:beginTime(), Fraction:new(3))
    lu.assertEquals(ts:endTime()  , Fraction:new(4))
end

function TestTimeSpan__spanCycles()
    local ts = TimeSpan:new(Fraction:new(3, 4), Fraction:new(7, 2))
    local spans = ts:spanCycles()
    lu.assertEquals(4, #(spans))
    lu.assertEquals(spans[1]:beginTime(), Fraction:new(3, 4))
    lu.assertEquals(spans[1]:endTime()  , Fraction:new(1, 1))
    lu.assertEquals(spans[2]:beginTime(), Fraction:new(1, 1))
    lu.assertEquals(spans[2]:endTime()  , Fraction:new(2, 1))
    lu.assertEquals(spans[3]:beginTime(), Fraction:new(2, 1))
    lu.assertEquals(spans[3]:endTime()  , Fraction:new(3, 1))
    lu.assertEquals(spans[4]:beginTime(), Fraction:new(3, 1))
    lu.assertEquals(spans[4]:endTime()  , Fraction:new(7, 2))
end

--os.exit( lu.LuaUnit.run() )
