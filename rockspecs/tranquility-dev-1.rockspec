package = "tranquility"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/XiNNiW/tranquility.git"
}
description = {
   summary = "a port of the tidalcycles pattern language to lua",
   detailed = [[
Tranquility is an experimental port of the livecoding music language [Tidalcycles](http://tidalcycles.org/) to the lua programming language.
This project follows in the footsteps of [vortex](https://github.com/tidalcycles/vortex) and [strudel](https://strudel.tidalcycles.org).
For me the main purpose of this project is to learn about how to implement a livecoding language.]],
   homepage = "https://github.com/XiNNiW/tranquility",
   license = "GPL3"
}
dependencies = {
    "lua >= 5.1",
    "losc >= 1.0.1-1",
    "luasocket >= 3.1.0-1"
}
build = {
   type = "builtin",
   modules = {
      compare_tables= "src/tranquility/compare_tables.lua",
      event = "src/tranquility/event.lua",
      fraction= "src/tranquility/fraction.lua",
      map = "src/tranquility/map.lua",
      pattern = "src/tranquility/pattern.lua",
      state = "src/tranquility/state.lua",
      stream = "src/tranquility/stream.lua",
      time_span = "src/tranquility/time_span.lua"
   },
  -- install = {
  --    bin = {"bin/tranquility"}
  -- }
}
