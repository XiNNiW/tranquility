--[[
Copyright (C) 2023 David Minnix

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]] --
local busted = require "busted"
local describe = busted.describe
local it = busted.it
require('tranquility/time_span')

describe("TimeSpan", function()
    describe("sam", function()
        it("should return the beginning of the cycle", function()
            local f = Fraction:new(3, 4)
            local sam = TimeSpan:sam(f)
            assert.are.equal(sam, Fraction:new(0, 1))
            f = Fraction:new(5, 4)
            sam = TimeSpan:sam(f)
            assert.are.equal(sam, Fraction:new(1, 1))
        end)
    end)
    describe("next sam", function()
        it("should return the beginning of next cycle", function()
            local f = Fraction:new(3, 4)
            local sam = TimeSpan:nextSam(f)
            assert.are.equal(sam, Fraction:new(1, 1))
            f = Fraction:new(5, 4)
            sam = TimeSpan:nextSam(f)
            assert.are.equal(sam, Fraction:new(2, 1))
        end)
    end)
    describe("wholeCycle", function()
        it("should return the large cycle that contains the span", function()
            local f1 = Fraction:new(1, 2)
            assert.are.equal(TimeSpan:new(Fraction:new(0, 1), Fraction:new(1, 1)), TimeSpan:wholeCycle(f1))
            f1 = Fraction:new(3, 2)
            assert.are.equal(TimeSpan:new(Fraction:new(1, 1), Fraction:new(2, 1)), TimeSpan:wholeCycle(f1))
        end)
    end)

    describe("cyclePos", function()
        it("should return the position within the cycle as a proper fraction", function()
            local f1 = Fraction:new(7, 2)
            assert.are.equal(Fraction:new(1, 2), TimeSpan:cyclePos(f1))
        end)
    end)

    describe("create", function()
        it("should create with defaults", function()
            local ts = TimeSpan:create()
            assert.are.equal(ts:beginTime(), Fraction:new(1))
            assert.are.equal(ts:endTime(), Fraction:new(1))
            ts = TimeSpan:create {}
            assert.are.equal(ts:beginTime(), Fraction:new(1))
            assert.are.equal(ts:endTime(), Fraction:new(1))
        end)
    end)

    describe("new", function()
        it("should create with arguments", function()
            local ts = TimeSpan:new(Fraction:new(3), Fraction:new(4))
            assert.are.equal(ts:beginTime(), Fraction:new(3))
            assert.are.equal(ts:endTime(), Fraction:new(4))
        end)
        it("should promote numbers to fractions", function()
            local ts = TimeSpan:new(0.5, 0.75)
            assert.are.equal(Fraction:new(1, 2), ts:beginTime())
            assert.are.equal(Fraction:new(3, 4), ts:endTime())
        end)

        it("should have a function declaring its type", function()
            local timeSpan = TimeSpan:new()
            assert.are.equal("tranquility.TimeSpan", timeSpan:type())
        end)
    end)

    describe("spanCycles", function()
        it("should break multi cycle span into pieces", function()
            local ts = TimeSpan:new(Fraction:new(3, 4), Fraction:new(7, 2))
            local spans = ts:spanCycles()
            assert.are.equal(4, spans:length())
            assert.are.equal(spans:at(1):beginTime(), Fraction:new(3, 4))
            assert.are.equal(spans:at(1):endTime(), Fraction:new(1, 1))
            assert.are.equal(spans:at(2):beginTime(), Fraction:new(1, 1))
            assert.are.equal(spans:at(2):endTime(), Fraction:new(2, 1))
            assert.are.equal(spans:at(3):beginTime(), Fraction:new(2, 1))
            assert.are.equal(spans:at(3):endTime(), Fraction:new(3, 1))
            assert.are.equal(spans:at(4):beginTime(), Fraction:new(3, 1))
            assert.are.equal(spans:at(4):endTime(), Fraction:new(7, 2))
        end)
        it("should preserve subcycle length spans", function()
            local ts = TimeSpan:new(Fraction:new(1, 16), Fraction:new(1, 1))
            local spans = ts:spanCycles()
            assert.are.equal(1, spans:length())
            assert.are.equal(spans:at(1):beginTime(), Fraction:new(1, 16))
            assert.are.equal(spans:at(1):endTime(), Fraction:new(1, 1))
        end)
    end)

    describe("duration", function()
        it("should return the duration of the span", function()
            local ts = TimeSpan:new(Fraction:new(3, 4), Fraction:new(7, 2))
            assert.are.equal(ts:duration(), Fraction:new(11, 4))
            ts = TimeSpan:new(Fraction:new(6, 7), Fraction:new(10, 11))
            assert.are.equal(ts:duration(), Fraction:new(4, 77))
        end)
    end)

    describe("cycleArc", function()
        it("should return the span as if it started in cycle 0", function()
            local ts = TimeSpan:new(Fraction:new(5, 4), Fraction:new(11, 4))
            assert.are.equal(ts:cycleArc(), TimeSpan:new(Fraction:new(1, 4), Fraction:new(7, 4)))
        end)
    end)

    describe("midpoint", function()

        it("should return the middle point between span begin and end", function()
            local ts = TimeSpan:new(Fraction:new(0, 1), Fraction:new(1, 1))
            assert.are.equal(ts:midpoint(), Fraction:new(1, 2))
            ts = TimeSpan:new(Fraction:new(7, 11), Fraction:new(5, 4))
            assert.are.equal(ts:midpoint(), Fraction:new(83, 88))
        end)
    end)

    describe("equals", function()
        it("should compare properties",
            function()
                local ts1 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(5, 4))
                local ts2 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(5, 4))
                assert.are.equal(ts1, ts2)
                ts1 = TimeSpan:new(Fraction:new(4, 8), Fraction:new(5, 4))
                ts2 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(10, 8))
                assert.are.equal(ts1, ts2)
            end)
    end)

    describe("show", function()
        it("should return string representation of span begin and end", function()
            local ts = TimeSpan:new(Fraction:new(1, 2), Fraction:new(5, 4))
            assert.are.equal(ts:show(), "1/2 → 5/4")
        end)
    end)

    describe("withTime", function()
        it("should return new span with modified begin time", function()
            local add1 = function(other)
                return other + Fraction:new(1, 1)
            end
            local ts = TimeSpan:new(Fraction:new(1, 2), Fraction:new(5, 6))
            assert.are.equal(ts:withTime(add1), TimeSpan:new(Fraction:new(3, 2), Fraction:new(11, 6)))
        end)
    end)

    describe("withEnd", function()
        it("should return new span with modified end time", function()
            local add1 = function(other)
                return other + Fraction:new(1, 1)
            end
            local ts = TimeSpan:new(Fraction:new(1, 2), Fraction:new(5, 6))
            assert.are.equal(ts:withEnd(add1), TimeSpan:new(Fraction:new(1, 2), Fraction:new(11, 6)))
        end)
    end)

    describe("intersection", function()
        -- I am uncomfortable with this function returning nil...
        -- I will consider a refactor after I have a working system
        it("should return the common timespan between two spans", function()
            local ts1 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(5, 4))
            local ts2 = TimeSpan:new(Fraction:new(2, 3), Fraction:new(2, 2))
            local expected = TimeSpan:new(Fraction:new(2, 3), Fraction:new(2, 2))
            assert.are.equal(ts1:intersection(ts2), expected)
            assert.are.equal(ts2:intersection(ts1), expected)
            ts1 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(5, 4))
            ts2 = TimeSpan:new(Fraction:new(5, 4), Fraction:new(7, 4))
            assert.is_nil(ts1:intersection(ts2))
            assert.is_nil(ts2:intersection(ts1))
            ts1 = TimeSpan:new(Fraction:new(5, 4), Fraction:new(6, 4))
            ts2 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
            assert.is_nil(ts1:intersection(ts2))
        end)
    end)

    describe("intersection_e", function()
        -- I am also uncomfortable with this function as a solution
        -- I will be curious to see if both are used
        it("should return intersection and throw exception if none", function()
            local ts1 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(5, 4))
            local ts2 = TimeSpan:new(Fraction:new(2, 3), Fraction:new(2, 2))
            local expected = TimeSpan:new(Fraction:new(2, 3), Fraction:new(2, 2))
            assert.are.equal(ts1:intersection_e(ts2), expected)
            assert.are.equal(ts2:intersection_e(ts1), expected)
            ts1 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(5, 4))
            ts2 = TimeSpan:new(Fraction:new(5, 4), Fraction:new(7, 4))
            assert.has_error(function() ts1:intersection_e(ts2) end)
            assert.has_error(function() ts2:intersection_e(ts1) end)
            ts1 = TimeSpan:new(Fraction:new(5, 4), Fraction:new(6, 4))
            ts2 = TimeSpan:new(Fraction:new(1, 2), Fraction:new(3, 4))
            assert.has_error(function() ts1:intersection_e(ts2) end)
        end)
    end)
end)
