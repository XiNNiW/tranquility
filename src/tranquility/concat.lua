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
require('tranquility.dump')

function Concat(list)

    local function _flatten(state, sublist, depth)
        --local MAX_DEPTH = 8
        for _, item in pairs(sublist) do
            if type(item) == "table" then
                state.flattened[state.index] = _flatten(state, item, depth + 1)
            else
                state.flattened[state.index] = item
            end
            state.index = state.index + 1
        end
    end

    local state = {
        index = 0,
        flattened = {}
    }
    _flatten(state, list, 0)
    print("concat")
    print(Dump(state.flattened))
    return state.flattened
end
