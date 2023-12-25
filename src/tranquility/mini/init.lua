--- a parser for mini-notation
-- @module mini.init
require("tranquility.mini.visitor")

--- Parse_mini takes a string of mini code and returns an AST
-- @tparam string code string of mini-notation
-- @treturn table AST
function Parse_mini(code)
	local raw_ast = Parse(code)
	return Visitor:visit(raw_ast)
end

--- Mini takes a string of mini code and returns the result pattern by evaluating it
-- @tparam string code string of mini-notation
-- @treturn tranquility.pattern result pattern
function Mini(code)
	local ast = Parse_mini(code)
	return Eval:eval(ast)
end
