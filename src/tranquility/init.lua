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
]]--
require("tranquility/pattern")
require("tranquility/event")
require("tranquility/fraction")
require("tranquility/stream")
require("tranquility/state")
require("tranquility/time_span")
require("tranquility/map")
require("tranquility/compare_tables")

local tranquility = {
  _VERSION = 'tranquility dev-1',
  _URL = 'https://github.com/xinniw/tranquility',
  _DESCRIPTION = 'A language for algorithmic pattern. Tidalcycles for lua',
  _LICENSE = [[
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
}
tranquility._index = tranquility

return tranquility
