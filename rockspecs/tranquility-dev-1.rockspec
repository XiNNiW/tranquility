package = "tranquility"
version = "dev-1"
source = {
	url = "git+ssh://git@github.com/XiNNiW/tranquility.git",
}
description = {
	summary = "a port of the tidalcycles pattern language to lua",
	detailed = [[
Tranquility is an experimental port of the livecoding music language [Tidalcycles](http://tidalcycles.org/) to the lua programming language.
This project follows in the footsteps of [vortex](https://github.com/tidalcycles/vortex) and [strudel](https://strudel.tidalcycles.org).
For me the main purpose of this project is to learn about how to implement a livecoding language.]],
	homepage = "https://github.com/XiNNiW/tranquility",
	license = "GPL3",
}
dependencies = {
	"lua >= 5.1",
	"luasec >= 1.2.0-1",
	"losc >= 1.0.1-1",
	"luasocket >= 3.1.0-1",
	"abletonlink >= 1.0.0-1",
	"lpeg" >= "1.1.0-1",
}
build = {
	type = "builtin",
	modules = {
		["tranquility.init"] = "src/tranquility/init.lua",
		["tranquility.compare_tables"] = "src/tranquility/compare_tables.lua",
		["tranquility.dump"] = "src/tranquility/dump.lua",
		["tranquility.fraction"] = "src/tranquility/fraction.lua",
		["tranquility.time_span"] = "src/tranquility/time_span.lua",
		["tranquility.event"] = "src/tranquility/event.lua",
		["tranquility.state"] = "src/tranquility/state.lua",
		["tranquility.pattern"] = "src/tranquility/pattern.lua",
		["tranquility.control"] = "src/tranquility/control.lua",
		["tranquility.link_clock"] = "src/tranquility/link_clock.lua",
		["tranquility.list"] = "src/tranquility/list.lua",
		["tranquility.stream_target"] = "src/tranquility/stream_target.lua",
		["tranquility.stream"] = "src/tranquility/stream.lua",
		["tranquility.type"] = "src/tranquility/type.lua",
		["tranquility.pattern_factory"] = "src/tranquility/pattern_factory.lua",
		["tranquility.mini"] = "src/tranquility/mini/init.lua",
		["tranquility.mini.grammar"] = "src/tranquility/mini/grammar.lua",
		["tranquility.mini.visitor"] = "src/tranquility/mini/visitor.lua",
		["tranquility.mini.targets"] = "src/tranquility/mini/targets.lua",
	},
	-- install = {
	--    bin = {"bin/tranquility"}
	-- }
}
