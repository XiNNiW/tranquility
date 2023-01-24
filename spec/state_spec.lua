
local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/state')

describe("State", function()
    describe("Create", function()

        function TestState__create()
            local expectedSpan = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
            local expectedControls = { something = "something else" }
            local state = State:create {
                _span = expectedSpan,
                _controls = expectedControls
            }
            assert.are.equal(state._span, expectedSpan)
            assert.are.equal(state._controls, expectedControls)
        end
    end)
    describe("New", function()

        function TestState__new()

            local expectedControls = { something = "something else" }
            local state = State:new(
                TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4)),
                expectedControls
            )
            assert.are.equal(state._span, TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4)))
            assert.are.equal(state._controls, expectedControls)
        end
    end)

    describe("setSpan", function()
        it("should return new state with specified span",
            function()
                local initialSpan = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
                local finalSpan = TimeSpan:new(Fraction:new(2, 3), Fraction:new(5, 6))
                local state = State:new(
                    initialSpan,
                    { something = "something else" }
                )
                state = state:setSpan(finalSpan)
                assert.are.equal(state._span, finalSpan)
            end)
    end)
    describe("withSpan", function()
        it("should return new state with span modified by the function",

            function()
                local initialSpan = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
                local expectedSpan = TimeSpan:new(Fraction:new(2, 3), Fraction:new(5, 6))
                local spanFunc = function() return expectedSpan end
                local state = State:new(
                    initialSpan,
                    { something = "something else" }
                )
                state = state:withSpan(spanFunc)
                assert.are.equal(state._span, expectedSpan)
            end)
    end)
    describe("setControls", function()
        it("should return new state with specified controls",
            function()
                local initialControls = { something = "something else" }
                local finalControls = { something = "something else" }
                local state = State:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4)),
                    initialControls
                )
                state = state:setControls(finalControls)
                assert.are.equal(state._controls, finalControls)
            end)
    end)
    describe("equals", function()
        it("should compare all properties",
            function()
                local state1 = State:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4)),
                    { something = "red fish" }
                )
                local state2 = State:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4)),
                    { something = "red fish" }
                )
                local state3 = State:new(
                    TimeSpan:new(Fraction:new(1, 3), Fraction:new(3, 4)),
                    { something = "red fish" }
                )
                local state4 = State:new(
                    TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4)),
                    { something = "blue fish" }
                )
                assert.is_true(state1 == state2)
                assert.is_false(state1 == state3)
                assert.is_false(state1 == state4)
            end)
    end)
end)
