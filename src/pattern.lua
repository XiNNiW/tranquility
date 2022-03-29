require("math")
require('src/time_span')

Pattern = {_query=function(t)end}

function Pattern:new(query)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o._query = query
    return o
end

function Pattern.split_queries()

end
