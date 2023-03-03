# Tranquility

Tranquility is an experimental port of the livecoding music language [Tidalcycles](http://tidalcycles.org/) to the lua programming language.
This project follows in the footsteps of [vortex](https://github.com/tidalcycles/vortex) and [strudel](https://strudel.tidalcycles.org).
For me the main purpose of this project is to learn about how to implement a livecoding language.


## Getting started
### Disclaimer
This project is under heavy development at the moment and is not at all stable. That said, please feel free to give it a try. All instructions assume some flavor of linux for now. There is no reason it **shouldn't** work on Mac or Windows that I know of but I haven't tried. There are likely additional hoops to jump through for those operating systems.

## dependencies
You will need the following (they may have different names in your package manager):
1. liblua5.4-dev, openssl, libssl-dev, and libasio-dev

## steps
1. clone or download the project zip from github
2. open a terminal in the project directory
3. run the following command: `luarocks install --only-deps rockspecs/tranquility-dev-1.rockspec`
4. `./actions/build.sh` (you may need sudo)
5. start supercollider and (in supercollider) run `SuperDirt.start;`
6. `./lua gabba_zero.lua`





