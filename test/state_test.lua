---@diagnostic disable: different-requires
local lu = require('test/luaunit/luaunit')
require('src/state')

function TestState__create()
    local expectedSpan = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local expectedControls = {something="something else"}
    local state = State:create{
        _span=expectedSpan,
        _controls=expectedControls
    }
    lu.assertEquals(state._span, expectedSpan)
    lu.assertEquals(state._controls, expectedControls)
end

function TestState__new()

    local expectedControls = {something="something else"}
    local state = State:new(
        TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4)),
        expectedControls
    )
    lu.assertEquals(state._span, TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4)))
    lu.assertEquals(state._controls, expectedControls)
end

function TestState__setSpan()
    local initialSpan = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local finalSpan = TimeSpan:new(Fraction:new(2,3),Fraction:new(5,6))
    local state = State:new(
        initialSpan,
        {something="something else"}
    )
    state = state:setSpan(finalSpan)
    lu.assertEquals(state._span, finalSpan)
end

function TestState__withSpan()
    local initialSpan = TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4))
    local expectedSpan = TimeSpan:new(Fraction:new(2,3),Fraction:new(5,6))
    local spanFunc = function() return expectedSpan end
    local state = State:new(
        initialSpan,
        {something="something else"}
    )
    state = state:withSpan(spanFunc)
    lu.assertEquals(state._span, expectedSpan)
end

function TestState__setControls()
    local initialControls = {something="something else"}
    local finalControls = {something="something else"}
    local state = State:new(
        TimeSpan:new(Fraction:new(1,2),Fraction:new(3,4)),
        initialControls
    )
    state = state:setControls(finalControls)
    lu.assertEquals(state._controls, finalControls)
end

function TestState__equals()
    local state1 = State:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(3,4)),
        {something="red fish"}
    )
    local state2 = State:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(3,4)),
        {something="red fish"}
    )
    local state3 = State:new(
        TimeSpan:new(Fraction:new(1,3), Fraction:new(3,4)),
        {something="red fish"}
    )
    local state4 = State:new(
        TimeSpan:new(Fraction:new(1,2), Fraction:new(3,4)),
        {something="blue fish"}
    )
    lu.assertTrue(state1==state2)
    lu.assertFalse(state1==state3)
    lu.assertFalse(state1==state4)
end
