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
require("tranquility.compare_tables")
require("tranquility.event")
require("tranquility.stream")
require("tranquility.time_span")
require("tranquility.pattern")
require("tranquility.control")
require("tranquility.pattern_factory")

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

tranquility.p = P
tranquility.s = S
tranquility.cat = Slowcat
tranquility.hush = Hush
tranquility.Pure = Pure
tranquility.Clock = DefaultClock


--function OscTest()
--    local _ = p("bd")
--    DefaultClock.start()
--end

return tranquility
