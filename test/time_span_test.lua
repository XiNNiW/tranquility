---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/time_span')

function TestTimeSpan_sam()
    local f = Fraction:new(3,4)
    local sam = TimeSpan:sam(f)
    lu.assertEquals(sam,Fraction:new(0,1))
    f = Fraction:new(5,4)
    sam = TimeSpan:sam(f)
    lu.assertEquals(sam,Fraction:new(1,1))
end

function TestTimeSpan_nextSam()
    local f = Fraction:new(3,4)
    local sam = TimeSpan:nextSam(f)
    lu.assertEquals(sam,Fraction:new(1,1))
    f = Fraction:new(5,4)
    sam = TimeSpan:nextSam(f)
    lu.assertEquals(sam,Fraction:new(2,1))
end

function TestTimeSpan_wholeCycle()
    local ts = TimeSpan:new(Fraction:new(3,4), Fraction:new(4,4))
    local cycle = ts:wholeCycle()
    lu.assertEquals(cycle:beginTime(), Fraction:new(0))
    lu.assertEquals(cycle:endTime(), Fraction:new(1))
end

function TestTimeSpan__create()
    local ts = TimeSpan:create()
    lu.assertEquals(Fraction:new(1), ts:beginTime())
    lu.assertEquals(Fraction:new(1), ts:endTime())
    ts = TimeSpan:create{}
    lu.assertEquals(Fraction:new(1), ts:beginTime())
    lu.assertEquals(Fraction:new(1), ts:endTime())
end

function TestTimeSpan__new()
    local ts = TimeSpan:new(Fraction:new(3), Fraction:new(4))
    lu.assertEquals(Fraction:new(3), ts:beginTime())
    lu.assertEquals(Fraction:new(4), ts:endTime())
end


-- function TestTimeSpan__spanCycles()
--     local ts = TimeSpan:new(Fraction:new(3), Fraction:new(4))
--     local spans = ts:spanCycles()
--     lu.assertEquals(Fraction:new(1), ts:beginTime())
--     lu.assertEquals(Fraction:new(1), ts:endTime())
    
-- end

--os.exit( lu.LuaUnit.run() )
