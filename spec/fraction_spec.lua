local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/fraction')

describe("Fraction", function()

    it("should create with default values",
        function()
            local f = Fraction:create()
            assert.are.equal(f:numerator(), 0)
            assert.are.equal(f:denominator(), 1)
            f = Fraction:create { _numerator = 1, _denominator = 2 }
            assert.are.equal(f:numerator(), 1)
            assert.are.equal(f:denominator(), 2)
        end)

    it("should new with arguments",
        function()
            local f = Fraction:new()
            assert.are.equal(f:numerator(), 0)
            assert.are.equal(f:denominator(), 1)
            f = Fraction:new(3, 4)
            assert.are.equal(f:numerator(), 3)
            assert.are.equal(f:denominator(), 4)
            f = Fraction:new(6, 8)
            assert.are.equal(f:numerator(), 3)
            assert.are.equal(f:denominator(), 4)
            f = Fraction:new(-4, 8)
            assert.are.equal(f:numerator(), -1)
            assert.are.equal(f:denominator(), 2)
            f = Fraction:new(4, -8)
            assert.are.equal(f:numerator(), -1)
            assert.are.equal(f:denominator(), 2)
            f = Fraction:new(-4, -8)
            assert.are.equal(f:numerator(), 1)
            assert.are.equal(f:denominator(), 2)
            -- Does Fraction need to reduce decimal numbers to closest approximation?
            --f = Fraction:new(1.5, 7.6)
            -- assert.are.equal(f:numerator(), 1.5)
            -- assert.are.equal(f:denominator(), 7.6)
        end)

    it("should throw on divide by zero", function()
        assert.has_error(function ()
            return Fraction:new(1,0)
        end)

    end)

    -- Does Fraction need to infer fraction from string representation?
    --function TestFractional__new__fromString()
    --    local f = Fraction:new("1/2")
    --    assert.are.equal(f:numerator(), 1)
    --    assert.are.equal(f:denominator(), 2)
    --end
    it("should add",
        function()
            local f1 = Fraction:new(1, 2)
            local f2 = Fraction:new(1, 2)
            assert.are.equal(f1 + f2, Fraction:new(1))
            f1 = Fraction:new(1, 2)
            f2 = Fraction:new(1, 3)
            -- 3/6 + 2/6
            assert.are.equal(f1 + f2, Fraction:new(5, 6))
            f1 = Fraction:new(1, 2)
            f2 = Fraction:new(-1, 3)
            -- 3/6 + -2/6
            assert.are.equal(f1 + f2, Fraction:new(1, 6))
        end)

    it("should subtract",
        function()
            local f1 = Fraction:new(1, 2)
            local f2 = Fraction:new(1, 2)
            assert.are.equal(f1 - f2, Fraction:new(0))
            f1 = Fraction:new(1, 2)
            f2 = Fraction:new(1, 3)
            -- 3/6 - 2/6
            assert.are.equal(f1 - f2, Fraction:new(1, 6))
            f1 = Fraction:new(1, 2)
            f2 = Fraction:new(-1, 3)
            -- 3/6 - -2/6
            assert.are.equal(f1 - f2, Fraction:new(5, 6))
        end)

    it("should multiply",
        function()
            local f1 = Fraction:new(1, 2)
            local f2 = Fraction:new(1, 2)
            assert.are.equal(f1 * f2, Fraction:new(1, 4))
            f1 = Fraction:new(1, 2)
            f2 = Fraction:new(1, 3)
            assert.are.equal(f1 * f2, Fraction:new(1, 6))
            f1 = Fraction:new(1, 2)
            f2 = Fraction:new(-1, 3)
            assert.are.equal(f1 * f2, Fraction:new(-1, 6))
        end)
    it("should divide",
        function()
            local f1 = Fraction:new(1, 2)
            local f2 = Fraction:new(1, 2)
            assert.are.equal(f1 / f2, Fraction:new(1))
            f1 = Fraction:new(1, 2)
            f2 = Fraction:new(1, 3)
            assert.are.equal(f1 / f2, Fraction:new(3, 2))
            f1 = Fraction:new(1, 2)
            f2 = Fraction:new(-1, 3)
            assert.are.equal(f1 / f2, Fraction:new(-3, 2))
        end)

    it("should support mod",
        function()
            local f1 = Fraction:new(1, 2)
            local f2 = Fraction:new(2, 3)
            assert.are.equal(f1 % f2, Fraction:new(1, 2))
            f1 = Fraction:new(3, 4)
            f2 = Fraction:new(2, 3)
            -- 9/12 % 8/12 = 1/12
            assert.are.equal(f1 % f2, Fraction:new(1, 12))
        end)

    it("should be able to be raised to a power",
        function()
            local f1 = Fraction:new(1, 4)
            local f2 = Fraction:new(1, 2)
            assert.are.equal(f1 ^ f2, 0.5)
            f1 = Fraction:new(1, 4)
            f2 = Fraction:new(2, 1)
            assert.are.equal(f1 ^ f2, Fraction:new(1, 16))
        end)

    it("should support negative operator",
        function()
            local f1 = Fraction:new(1, 4)
            assert.are.equal(-f1, Fraction:new(-1, 4))
        end)

    it("should be able to be floored",
        function()
            local f1 = Fraction:new(1, 4)
            assert.are.equal(f1:floor(), 0)
            f1 = Fraction:new(5, 4)
            assert.are.equal(f1:floor(), 1)
            f1 = Fraction:new(9, 4)
            assert.are.equal(f1:floor(), 2)
        end)

    it("should support greater than comparison",
        function()
            assert.is_true(Fraction:new(3, 4) > Fraction:new(1, 3))
            assert.is_true(Fraction:new(5, 4) > Fraction:new(1, 1))
            assert.is_false(Fraction:new(1, 3) > Fraction:new(1, 2))
            assert.is_false(Fraction:new(5, 4) > Fraction:new(7, 4))
        end)

    it("should support less than comparison",
        function()
            assert.is_true(Fraction:new(1, 4) < Fraction:new(1, 3))
            assert.is_true(Fraction:new(1, 4) < Fraction:new(1, 3))
            assert.is_true(Fraction:new(5, 4) < Fraction:new(7, 3))
            assert.is_false(Fraction:new(2, 3) < Fraction:new(1, 2))
            assert.is_false(Fraction:new(9, 1) < Fraction:new(7, 4))
        end)

    it("should support greater than or equal to comparison",
        function()
            assert.is_true(Fraction:new(3, 4) >= Fraction:new(1, 3))
            assert.is_true(Fraction:new(1, 3) >= Fraction:new(1, 3))
            assert.is_true(Fraction:new(-1, 3) >= Fraction:new(-7, 3))
            assert.is_true(Fraction:new(5, 4) >= Fraction:new(5, 4))
            assert.is_false(Fraction:new(1, 3) >= Fraction:new(1, 2))
            assert.is_false(Fraction:new(5, 4) >= Fraction:new(7, 4))
        end)

    it("should support less than or equal to comparison",
        function()
            assert.is_true(Fraction:new(1, 4) <= Fraction:new(1, 3))
            assert.is_true(Fraction:new(1, 4) <= Fraction:new(1, 4))
            assert.is_true(Fraction:new(5, 4) <= Fraction:new(7, 3))
            assert.is_true(Fraction:new(-5, 4) <= Fraction:new(7, 3))
            assert.is_false(Fraction:new(2, 3) <= Fraction:new(1, 2))
            assert.is_false(Fraction:new(9, 1) <= Fraction:new(7, 4))
        end)

    it("should support equal to comparison",
        function()
            assert.is_true(Fraction:new(1, 4) == Fraction:new(1, 4))
            assert.is_true(Fraction:new(5, 4) == Fraction:new(10, 8))
            assert.is_true(Fraction:new(-2, 3) == Fraction:new(8, -12))
            assert.is_true(Fraction:new(-1, 3) == Fraction:new(-3, 9))
            assert.is_false(Fraction:new(254, 255) == Fraction:new(255, 256))
        end)

    it("should support min",
        function()
            assert.are.equal(Fraction:new(3, 4):min(Fraction:new(5, 6)), Fraction:new(3, 4))
            assert.are.equal(Fraction:new(3, 4):min(Fraction:new(3, 6)), Fraction:new(3, 6))
            assert.are.equal(Fraction:new(3, 4):min(Fraction:new(-5, 6)), Fraction:new(-5, 6))
            assert.are.equal(Fraction:new(-3, 4):min(Fraction:new(-5, 6)), Fraction:new(-5, 6))
        end)

    it("should support max",
        function()
            assert.are.equal(Fraction:new(3, 4):max(Fraction:new(5, 6)), Fraction:new(5, 6))
            assert.are.equal(Fraction:new(3, 4):max(Fraction:new(3, 6)), Fraction:new(3, 4))
            assert.are.equal(Fraction:new(3, 4):max(Fraction:new(-5, 6)), Fraction:new(3, 4))
            assert.are.equal(Fraction:new(-3, 4):max(Fraction:new(-5, 6)), Fraction:new(-3, 4))
        end)

    it("should show string representation",
        function()
            assert.are.equal(Fraction:new(1, 2):show(), "1/2")
        end)

end)
