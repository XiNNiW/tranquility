---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('test/fractional_test')
require('test/pattern_test')
require('test/time_span_test')

os.exit( lu.LuaUnit.run() )
