---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('test/compare_tables_test')
require('test/fraction_test')
require('test/pattern_test')
require('test/time_span_test')
require('test/event_test')
require('test/state_test')
require('test/map_test')
require('test/stream_test')

os.exit( lu.LuaUnit.run() )
