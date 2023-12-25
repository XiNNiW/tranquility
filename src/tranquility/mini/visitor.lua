--- returns the meaningful part in AST
-- @module mini.visitor

require("tranquility.mini.grammar")
local unpack = table.unpack or _G.unpack

--- turn parse trees into something useful
-- performs a depth-first traversal of an AST
-- simulates the NodeVisitor class from python module `parsimonious`
-- @type Visitor
Visitor = {}

--- visit a node
-- @tparam table node
-- @treturn table
function Visitor:visit(node)
	local type = node[1]
	local method = self[type]
	if node[3] ~= nil then
		local children = {}
		for i = 3, #node do
			children[#children + 1] = node[i]
		end
		for i, subnode in pairs(children) do
			children[i] = self:visit(subnode)
		end
		return method(self, node, children)
	else
		return method(self, node, "")
	end
end

function Visitor:root(_, children)
	return children[1]
end

function Visitor:sequence(_, children)
	local group, other_groups, other_seqs = unpack(children)
	if other_groups ~= "" then
		local elements = {
			{ type = "element", value = { type = "polyrhythm", seqs = { group } }, modifiers = {} },
		}
		for _, item in pairs(other_groups) do
			elements[#elements + 1] = {
				type = "element",
				value = {
					type = "polyrhythm",
					seqs = { item },
				},
				modifiers = {},
			}
		end
		group = { type = "sequence", elements = elements }
	end
	if other_seqs ~= "" then
		local n_seq = { group }
		for _, item in pairs(other_seqs) do
			n_seq[#n_seq + 1] = item
		end
		return { type = "random_sequence", elements = n_seq }
	end
	return group
end

function Visitor:group(_, children)
	local element, other_elements = unpack(children)
	local n_element = { element }
	if other_elements ~= "" then
		for _, e in pairs(other_elements) do
			n_element[#n_element + 1] = e
		end
	end
	return { type = "sequence", elements = n_element }
end

function Visitor:other(_, children)
	return children or ""
end

function Visitor:element(_, children)
	local value, euclid_modifier, modifiers, e_weight = unpack(children)
	local weight_mods = {}
	local n_modifiers = {}
	for _, mod in pairs(modifiers) do
		if mod.op == "weight" then
			weight_mods[#weight_mods + 1] = mod
		else
			n_modifiers[#n_modifiers + 1] = mod
		end
	end
	local weight_mod = weight_mods[1] or { type = "modifier", op = "weight", value = e_weight }
	if weight_mod.value ~= 1 then
		n_modifiers[#n_modifiers + 1] = weight_mod
	end
	local element = { type = "element", value = value, modifiers = n_modifiers }
	element.euclid_modifier = euclid_modifier
	return element
end

function Visitor:polyrhythm_subseq(_, children)
	return { type = "polyrhythm", seqs = children[1] }
end

function Visitor:polymeter_subseq(_, children)
	local seqs, steps = unpack(children)
	return { type = "polymeter", seqs = seqs, steps = steps or 1 }
end

function Visitor:polymeter_steps(_, children)
	return children[1]
end

function Visitor:polymeter1_subseq(_, children)
	local seqs = children[1]
	return { type = "polymeter", seqs = seqs, steps = 1 }
end

function Visitor:subseq_body(_, children)
	local seq, other_seqs = unpack(children)
	local n_subseq = { seq }
	if other_seqs ~= "" then
		for _, subseq in pairs(other_seqs) do
			n_subseq[#n_subseq + 1] = subseq
		end
	end
	return n_subseq
end

function Visitor:elongate(node, _)
	return #node[2] / 2 + 1
end

function Visitor:element_value(_, children)
	return children[1]
end

function Visitor:term(_, children)
	if type(children[1]) == "number" then
		return { type = "number", value = children[1] }
	end
	return children[1]
end

function Visitor:rest(_, _)
	return { type = "rest" }
end

function Visitor:word_with_index(_, children)
	local word, index = unpack(children)
	return { type = "word", value = word, index = index or 0 }
end

function Visitor:index(_, children)
	return children[1]
end

function Visitor:euclid_modifier(_, children)
	if children == "" then
		return
	end
	local k, n, rotation = unpack(children)
	if k ~= nil and n ~= nil then
		return { type = "euclid_modifier", k = k, n = n, rotation = rotation }
	end
end

function Visitor:euclid_rotation_param(_, children)
	return children[1]
end

function Visitor:modifiers(_, children)
	if children == "" then
		return {}
	end
	local mods, degrade_mods, weight_mods = {}, {}, {}
	local count_deg_mods, value_deg_mods = {}, {}
	for _, mod in pairs(children) do
		if mod.op == "degrade" then
			degrade_mods[#degrade_mods + 1] = mod
		elseif mod.op == "weight" then
			weight_mods[#weight_mods + 1] = mod
		else
			mods[#mods + 1] = mod
		end
	end
	if #degrade_mods ~= 0 then
		for _, mod in pairs(degrade_mods) do
			if mod.value.op == "count" then
				count_deg_mods[#count_deg_mods + 1] = mod
			elseif mod.value.op == "value" then
				value_deg_mods[#value_deg_mods + 1] = mod
			end
		end
	end
	if #value_deg_mods ~= 0 then
		mods[#mods + 1] = value_deg_mods[#value_deg_mods]
	elseif #count_deg_mods ~= 0 then
		local sum = 0
		for _, mod in pairs(count_deg_mods) do
			sum = sum + mod.value.value
		end
		mods[#mods + 1] =
			{ type = "modifier", op = "degrade", value = { type = "degrade_arg", op = "count", value = sum } }
	end
	mods[#mods + 1] = weight_mods[#weight_mods]
	return mods
end

function Visitor:modifier(_, children)
	return children[1]
end

function Visitor:fast(_, children)
	return { type = "modifier", op = "fast", value = children[1] }
end

function Visitor:slow(_, children)
	return { type = "modifier", op = "slow", value = children[1] }
end

function Visitor:_repeat(_, children)
	local sum = 0
	for _, v in pairs(children) do
		sum = sum + v
	end
	return { type = "modifier", op = "repeat", count = sum }
end

function Visitor:repeatn(_, children)
	return children[1]
end

function Visitor:repeat1(_, _)
	return 1
end

function Visitor:degrade(_, children)
	return { type = "modifier", op = "degrade", value = children[1] }
end

function Visitor:degrader(_, children)
	return { type = "degrade_arg", op = "value", value = children[1] }
end

function Visitor:degraden(_, children)
	return { type = "degrade_arg", op = "count", value = children[1] }
end

function Visitor:degrade1(_, _)
	return { type = "degrade_arg", op = "count", value = 1 }
end

function Visitor:weight(_, children)
	return { type = "modifier", op = "weight", value = children[1] }
end

function Visitor:word(node, _)
	return node[2]
end

function Visitor:number(_, children)
	return children[1]
end

function Visitor:integer(node, _)
	return tonumber(node[2])
end

function Visitor:real(node, _)
	return tonumber(node[2])
end

function Visitor:pos_integer(node, _)
	return tonumber(node[2])
end

function Visitor:pos_real(node, _)
	return tonumber(node[2])
end
