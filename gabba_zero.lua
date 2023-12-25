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
]]
--
require("coroutine")
t = require("tranquility")

print(t._VERSION)


local pat = t.p(1, t.s("gabba")):fast(t.cat({ 1, 2, 3, 4 }))

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

print("all done")
