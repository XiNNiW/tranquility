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
function CompareTables(_rhs, _lhs)

    if type(_lhs) ~= type(_rhs) then return false end
    if type(_lhs) == "table" then
        if TableSize(_lhs) ~= TableSize(_rhs) then return false end
        for k, v in pairs(_lhs) do
            local areEqual = CompareTables(v, _rhs[k])
            if (not areEqual) then return false end
        end
    else
        return (_rhs == _lhs)
    end
    return true
end

function TableSize(t)
    local size = 0;
    for _ in pairs(t) do size = size + 1 end
    return size
end
