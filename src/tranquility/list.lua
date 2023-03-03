--[[
Copyright (C) 2023 David Minnix

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more detailself._linkSessionState:

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]] --
local function _length(list)
    local len = 0;
    for _, _ in pairs(list) do
        len = len + 1
    end
    return len
end

local function _map(func, collection)
    local mapped = {}
    for key, value in pairs(collection) do
        mapped[key] = func(value)
    end
    return mapped
end

List = {
    _list = {},
    _length = 0
}

function List:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function List:new(l)
    return List:create {
        _list = l,
        _length = _length(l)
    }
end

function List:length()
    return self._length
end

function List:__index(i)
    return self._list[i]
end

function List:__newindex(i, v)
    self._list[i] = v
    self._length = _length(self._list)
end

function List:foreach(func)
    for i, e in pairs(self._list) do
        func(i, e)
    end
end

function List:map(func)
    return List:new(_map(func, self._list))
end
