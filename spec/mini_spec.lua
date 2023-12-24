local busted = require("busted")
local describe = busted.describe
local it = busted.it
local targets = require("tranquility.mini.targets")
require("tranquility.mini")

local function same(name)
	assert.same(targets[name], Parse_mini(name))
end

describe("Mini Parser for", function()
	describe("numbers", function()
		it("should pass", function()
			same("45")
			same("-2.")
			same("4.64")
			same("-3")
		end)
	end)

	describe("words", function()
		it("should pass", function()
			same("foo")
			same("Bar:2")
		end)
	end)

	describe("rests", function()
		it("should pass", function()
			same("~")
		end)
	end)

	describe("fast&slow", function()
		it("should pass", function()
			same("bd*2")
			same("bd/3")
		end)
	end)

	describe("degrade", function()
		it("should pass", function()
			same("hh?")
			same("hh???")
			same("hh?4")
			same("hh?4??")
			same("hh??0.87")
		end)
	end)

	describe("repeat", function()
		it("should pass", function()
			same("hh!")
			same("hh!!!")
			same("hh!4")
			same("hh!4!!")
		end)
	end)

	describe("weight", function()
		it("should pass", function()
			same("hh@2")
			same("bd _ _ sd")
		end)
	end)

	describe("hybrid mod", function()
		it("should pass", function()
			same("hh!!??!")
			same("hh!/2?!")
		end)
	end)

	describe("sequence", function()
		it("should pass", function()
			same("bd sd")
			same("bd hh sd")
			same("bd! hh? ~ sd/2 cp*3")
		end)
	end)

	describe("polymeter", function()
		it("should pass", function()
			-- same("bd*<2 3 4>")
			same("{bd sd hh cp hh}%4")
		end)
	end)

	describe("euclidian rhythm", function()
		it("should pass", function()
			same("1(3,8)")
		end)
	end)

	describe("polyrhythm", function()
		it("should pass", function()
			same("[bd sd] hh")
			same("bd sd . cp . hh*2")
			same("[bd, sd]")
		end)
	end)

	describe("random seq", function()
		it("should pass", function()
			same("bd | sd cp")
		end)
	end)
end)

local function eval(input, query_span, expected_pat)
	local pat = Mini(input)
	local span = query_span or TimeSpan:new(0, 1)
	assert.same(expected_pat, pat.query(span))
end

-- numbers
local tar = {
	-- { "45", nil, Pure(45) },
	-- 	{ "-2.", nil, Pure(-2.0) },
	-- 	{ "4.64", nil, Pure(4.64) },
	-- 	{ "-3", nil, Pure(-3) },
	-- 	-- words
	-- 	{ "foo", nil, Pure("foo") },
	-- 	{ "Bar", nil, Pure("Bar") },
	-- 	-- rest
	-- 	{ "~", nil, Silence() },
	-- 	-- modifiers
	-- 	{ "bd*2", nil, Fast(2, "bd") },
	-- 	{ "bd/3", nil, Slow(3, "bd") },
	-- 	{ "hh?", nil, Degrade("hh") },
	-- 	{ "hh??", nil, Degrade(Degrade("hh")) },
	-- 	{
	-- 		"hh!!??",
	-- 		nil,
	-- 		Degrade({ Degrade(Fastcat({ "hh", "hh", "hh" })) }),
	-- 	},
	-- 	-- sequences
	-- 	{ "bd sd", nil, Fastcat({ "bd", "sd" }) },
	-- 	{ "bd hh sd", nil, Fastcat({ "bd", "hh", "sd" }) },
	-- 	{ "hh@2", nil, Pure("hh") },
	-- 	{ "bd hh@2", nil, Timecat({ { 1, "bd" }, { 2, "hh" } }) },
	-- 	{ "bd hh@3 sd@2", nil, Timecat({ { 1, "bd" }, { 3, "hh" }, { 2, "sd" } }) },
	-- 	{ "hh!", nil, Fastcat({ "hh", "hh" }) },
	-- 	{ "hh!!", nil, Fastcat({ "hh", "hh", "hh" }) },
	-- 	{ "bd! cp", nil, Fastcat({ "bd", "bd", "cp" }) },
	-- 	{
	-- 		"bd! hh? ~ sd/2 cp*3",
	-- 		nil,
	-- 		Timecat({
	-- 			{ 1, "bd" },
	-- 			{ 1, "bd" },
	-- 			{ 1, Degrade("hh") },
	-- 			{ 1, Silence() },
	-- 			{ 1, Slow(2, "sd") },
	-- 			{ 1, Fast(3, "cp") },
	-- 			{ 1, Fast(3, "cp") },
	-- 			{ 1, Fast(3, "cp") },
	-- 		}),
	-- 	},
}
