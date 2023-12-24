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

## Collaboration

Collaboration is welcome! I would to work with other people in the community to help get this thing off the ground. I will be fairly busy until May 2024 and I might be a bit slow to review things until then.

### Pull Requests

For now I can review and merge pull requests. If I end up being a barrier I'm happy to hand things off.

### Testing

To help us keep things working as it grows I think we should write some kind of functional test for each piece of public facing functionality. If you want to write more tests to help you figure out whats going on with some piece of the internals that's OK. Please don't feel pressure to write the number of tests that I did for the core of tranquility. We can talk about how many of these tests we want to keep going forward. For now, please help me maintain them until we can write more comprehensive functional tests.
Before opening a pull request please make sure that all tests pass appropriately.
If a test is asserting something incorrectly please feel free to change the assertion. If a test is referencing functionality that is no longer a part of the production code, please replace it with one that does or, if needed, [delete](delete) it.






