---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/time_span')

function TestTimeSpan__sam()
    local f = Fraction:new(3, 4)
    local sam = TimeSpan:sam(f)
    lu.assertEquals(sam, Fraction:new(0, 1))
    f = Fraction:new(5, 4)
    sam = TimeSpan:sam(f)
    lu.assertEquals(sam, Fraction:new(1, 1))
end

function TestTimeSpan__nextSam()
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

function TestFraction__cyclePos()
    local f1 = Fraction:new(7, 2)
    lu.assertEquals(Fraction:new(1,2), TimeSpan:cyclePos(f1))
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

function TestTimeSpan__duration()
    local ts = TimeSpan:new(Fraction:new(3, 4), Fraction:new(7, 2))
    lu.assertEquals(ts:duration(), Fraction:new(11, 4))
    ts = TimeSpan:new(Fraction:new(6,7),Fraction:new(10,11))
    lu.assertEquals(ts:duration(), Fraction:new(4,77))
end

function TestTimeSpan__cycleArc()
    local ts = TimeSpan:new(Fraction:new(5,4), Fraction:new(11,4))
    lu.assertEquals(ts:cycleArc(), TimeSpan:new(Fraction:new(1,4), Fraction:new(7, 4)))
end

function TestTimeSpan__midpoint()
    local ts = TimeSpan:new(Fraction:new(0,1), Fraction:new(1,1))
    lu.assertEquals(ts:midpoint(), Fraction:new(1,2))
    ts = TimeSpan:new(Fraction:new(7,11), Fraction:new(5,4))
    lu.assertEquals(ts:midpoint(), Fraction:new(83,88))
end

function TestTimeSpan__equals()
    local ts1 = TimeSpan:new(Fraction:new(1,2), Fraction:new(5,4))
    local ts2 = TimeSpan:new(Fraction:new(1,2), Fraction:new(5,4))
    lu.assertEquals(ts1,ts2)
    ts1 = TimeSpan:new(Fraction:new(4,8), Fraction:new(5,4))
    ts2 = TimeSpan:new(Fraction:new(1,2), Fraction:new(10,8))
    lu.assertEquals(ts1,ts2)

end

function TestTimeSpan__show()
    local ts = TimeSpan:new(Fraction:new(1,2), Fraction:new(5,4))
    lu.assertEquals(ts:show(), "1/2 → 5/4")
end

function TestTimeSpan__withTime()
    local add1 = function (other)
        return other+Fraction:new(1,1)
    end
    local ts = TimeSpan:new(Fraction:new(1,2), Fraction:new(5,6))
    lu.assertEquals(ts:withTime(add1), TimeSpan:new(Fraction:new(3,2), Fraction:new(11,6)))
end

function TestTimeSpan__withEnd()
    local add1 = function (other)
        return other+Fraction:new(1,1)
    end
    local ts = TimeSpan:new(Fraction:new(1,2), Fraction:new(5,6))
    lu.assertEquals(ts:withEnd(add1), TimeSpan:new(Fraction:new(1,2), Fraction:new(11,6)))
end

-- I am uncomfortable with this function returning nil... 
-- I will consider a refactor after I have a working system
function TestTimeSpan__intersection()
    local ts1 = TimeSpan:new(Fraction:new(1,2), Fraction:new(5,4))
    local ts2 = TimeSpan:new(Fraction:new(2,3), Fraction:new(2,2))
    local expected = TimeSpan:new(Fraction:new(2,3),Fraction:new(2,2))
    lu.assertEquals(ts1:intersection(ts2), expected)
    lu.assertEquals(ts2:intersection(ts1), expected)
    ts1 = TimeSpan:new(Fraction:new(1,2), Fraction:new(5,4))
    ts2 = TimeSpan:new(Fraction:new(5,4), Fraction:new(7,4))
    lu.assertNil(ts1:intersection(ts2))
    lu.assertNil(ts2:intersection(ts1))
    ts1 = TimeSpan:new(Fraction:new(5,4), Fraction:new(6,4))
    ts2 = TimeSpan:new(Fraction:new(1,2), Fraction:new(3,4))
    lu.assertNil(ts1:intersection(ts2))
end

-- I am also uncomfortable with this function as a solution
-- I will be curious to see if both are used
function TestTimeSpan__intersection_e()
    local ts1 = TimeSpan:new(Fraction:new(1,2), Fraction:new(5,4))
    local ts2 = TimeSpan:new(Fraction:new(2,3), Fraction:new(2,2))
    local expected = TimeSpan:new(Fraction:new(2,3),Fraction:new(2,2))
    lu.assertEquals(ts1:intersection_e(ts2), expected)
    lu.assertEquals(ts2:intersection_e(ts1), expected)
    ts1 = TimeSpan:new(Fraction:new(1,2), Fraction:new(5,4))
    ts2 = TimeSpan:new(Fraction:new(5,4), Fraction:new(7,4))
    lu.assertError(function(t) ts1:intersection_e(t) end,ts2)
    lu.assertError(function(t) ts2:intersection_e(t) end,ts1)
    ts1 = TimeSpan:new(Fraction:new(5,4), Fraction:new(6,4))
    ts2 = TimeSpan:new(Fraction:new(1,2), Fraction:new(3,4))
    lu.assertError(function(t) ts1:intersection_e(t) end,ts2)

end
--os.exit( lu.LuaUnit.run() )
