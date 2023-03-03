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

local function _filter(collection, filterFunc)
    local filtered = {};
    for _, item in pairs(collection) do
        if filterFunc(item) then
            table.insert(filtered, item)
        end
    end
    return filtered
end

local function _listConcat(rhs, lhs)
    local newList = {}
    for index, value in pairs(rhs) do
        newList[index] = value
    end
    for index, value in pairs(lhs) do
        newList[index + _length(rhs)] = value
    end
    return newList
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
    l = l or {}
    return List:create {
        _list = l,
        _length = _length(l)
    }
end

function List:type()
    return "List"
end

function List:length()
    return self._length
end

function List:foreach(func)
    for i, e in pairs(self._list) do
        func(i, e)
    end
end

function List:filter(func)
    return List:new(_filter(self._list, func))
end

function List:map(func)
    return List:new(_map(func, self._list))
end

function List:concat(l2)
    return List:new(_listConcat(self._list, l2._list))
end

function List:at(index)
    return self._list[index]
end

function List:assign(index, value)
    self._list[index] = value
end

function List:insert(e)
    table.insert(self._list, e)
    self._length = self._length + 1
end

function List:remove(position)
    table.remove(self._list, position)
    self._length = self._length - 1
end

function List:flatten()

    local function _flatten(sublist, depth)
        --local MAX_DEPTH = 8
        local flattened = List:new()
        sublist:foreach(function(_, item)
            if (type(item) == "table") and (item:type() == "List") then
                flattened = flattened:concat(_flatten(item, depth + 1))
            else
                flattened:insert(item)
            end
        end)
        return flattened
    end

    return _flatten(self, 0)
end

function List:__pairs(_)
    return pairs(self._list)
end

function List:__concat(l2)
    return self:concat(l2)
end

function List:__index(_, i)
    print("index")
    print(i)
    return self._list[i]
end

function List:__newindex(_, i, v)
    self._list[i] = v
    self._length = _length(self._list)
end

function List:__eq(l2)
    if self:length() ~= l2:length() then
        return false
    end
    self:foreach(function(i, e)
        if l2:at(i) ~= e then
            return false
        end
    end)
    return true
end
