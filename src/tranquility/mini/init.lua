require("tranquility.mini.visitor")

function Parse_mini(code)
	local raw_ast = Parse(code)
	return Visitor:visit(raw_ast)
end

-- function Mini(code)
-- 	local ast = Parse_mini(code)
-- 	return Eval:eval(ast)
-- end
