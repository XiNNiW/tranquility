require("coroutine")
local t = require("tranquility")

print(t._VERSION)

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

local pat = t.p(1, t.s("gabba"))
t.Clock:start()

print(coroutine.resume(t.Clock._notifyCoroutine))
while coroutine.resume(t.Clock._notifyCoroutine) do
    --[[ poll for user input]]
    --
    print("boop")
end
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))
--print(coroutine.resume(t.Clock._notifyCoroutine))

print("all done")
