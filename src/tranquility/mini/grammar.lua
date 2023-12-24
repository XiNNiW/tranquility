local lpeg = require("lpeg")

local P, S, V, R = lpeg.P, lpeg.S, lpeg.V, lpeg.R
local C, Ct, Cc = lpeg.C, lpeg.Ct, lpeg.Cc

local function token(id, patt)
	return Ct(Cc(id) * C(patt))
end

local sequence = token("sequence", V("sequence"))
local group = token("group", V("group"))
local element = token("element", V("element"))
local element_value = token("element_value", V("element_value"))
local polyrhythm_subseq = token("polyrhythm_subseq", V("polyrhythm_subseq"))
local polymeter_subseq = token("polymeter_subseq", V("polymeter_subseq"))
local polymeter1_subseq = token("polymeter1_subseq", V("polymeter1_subseq"))
local polymeter_steps = token("polymeter_steps", V("polymeter_steps"))
local subseq_body = token("subseq_body", V("subseq_body"))
local term = token("term", V("term"))
local word_with_index = token("word_with_index", V("word_with_index"))
local index = token("index", V("index"))
local euclid_modifier = token("euclid_modifier", V("euclid_modifier"))
local euclid_rotation_param = token("euclid_rotation_param", V("euclid_rotation_param"))
local modifiers = token("modifiers", V("modifiers"))
local modifier = token("modifier", V("modifier"))
local fast = token("fast", V("fast"))
local slow = token("slow", V("slow"))
local repeat1 = token("repeat1", V("repeat1"))
local repeatn = token("repeatn", V("repeatn"))
local _repeat = token("_repeat", V("_repeat"))
local degrade = token("degrade", V("degrade"))
local degrade1 = token("degrade1", V("degrade1"))
local degrader = token("degrader", V("degrader"))
local degraden = token("degraden", V("degraden"))
local weight = token("weight", V("weight"))
local word = token("word", V("word"))
local number = token("number", V("number"))
local real = token("real", V("real"))
local pos_real = token("pos_real", V("pos_real"))
local integer = token("integer", V("integer"))
local pos_integer = token("pos_integer", V("pos_integer"))
local rest = token("rest", V("rest"))
local minus = V("minus")
local ws = V("ws")
local elongate = token("elongate", V("elongate"))

local other_groups = token("other", V("other_groups"))
local other_seqs = token("other", V("other_seqs"))
local other_subseqs = token("other", V("other_subseqs"))
local other_elements = token("other", V("other_elements"))

local grammar = lpeg.Ct(lpeg.C({
	"root",
	-- root
	root = token("root", ws ^ -1 * sequence * ws ^ -1),

	-- sequence
	sequence = group * other_groups * other_seqs,
	other_groups = (ws * -P("|") * P(".") * ws * group) ^ 0,
	other_seqs = (ws ^ -1 * P("|") * ws ^ -1 * sequence) ^ 0,
	group = element * other_elements,
	other_elements = (ws * -P(".") * element) ^ 0,

	-- element
	element = element_value * euclid_modifier * modifiers * elongate,
	element_value = term + polyrhythm_subseq + polymeter_subseq + polymeter1_subseq,
	elongate = (ws ^ -1 * P("_")) ^ 0,

	-- subsequences
	polyrhythm_subseq = P("[") * ws ^ -1 * subseq_body * ws ^ -1 * P("]"),
	polymeter_subseq = P("{") * ws ^ -1 * subseq_body * ws ^ -1 * P("}") * polymeter_steps ^ -1,
	polymeter1_subseq = P("<") * ws ^ -1 * subseq_body * ws ^ -1 * P(">"),
	polymeter_steps = P("%") * number,
	subseq_body = sequence * other_subseqs,
	other_subseqs = (ws ^ -1 * P(",") * ws ^ -1 * sequence) ^ 0,

	-- terms
	term = number + word_with_index + rest,
	word_with_index = word * index ^ -1,
	index = P(":") * number,

	-- eculid modifier
	euclid_modifier = (
		P("(")
		* ws ^ -1
		* sequence
		* ws ^ -1
		* P(",")
		* ws ^ -1
		* sequence
		* euclid_rotation_param ^ -1
		* ws ^ -1
		* P(")")
	) ^ 0,
	euclid_rotation_param = ws ^ -1 * P(",") * ws ^ -1 * sequence,

	-- term modifiers
	modifiers = modifier ^ 0,
	modifier = fast + slow + _repeat + degrade + weight,
	fast = P("*") * element,
	slow = P("/") * element,
	_repeat = (repeat1 + repeatn) ^ 1,
	repeatn = P("!") * -P("!") * pos_integer,
	repeat1 = P("!") * -pos_integer,
	degrade = degrade1 + degraden + degrader,
	degrader = P("?") * -P("?") * pos_real,
	degraden = P("?") * -pos_real * -P("?") * pos_integer,
	degrade1 = P("?") * -pos_integer * -pos_real,
	weight = P("@") * number,

	-- primitives
	word = R("az", "AZ") ^ 1,
	number = real + integer,
	real = integer * P(".") * pos_integer ^ -1,
	pos_real = pos_integer * P(".") * pos_integer ^ -1,
	integer = minus ^ -1 * pos_integer,
	pos_integer = -minus * R("09") ^ 1,
	rest = P("~"),

	-- Misc
	minus = P("-"),
	ws = S(" \t") ^ -1,
}))

function Parse(string)
	return grammar:match(string)[2]
end
