--[[
-- colors.lua
-- Colors module
-- Contains colors, and possibly some functions someday
-- ]]

--
-- So, some temp. palette colors:
-- Black / Ground: 0x070707
-- Blue / Sky: 0x0B3954
-- Red / Blood: 0xB80C09
-- White / Moon: 0xFDFFFC
-- Lighter Blue / ??: 0x1F7A8C
-- Silver: 0xBFD7EA
--
-- Black: 0, 0, 0
-- White: 255, 255, 255
-- Dark Blue: 0x27213C
-- Dark Red: 0x690500
--

local Colors = {}

Colors ["DarkGrey"] = {0x07, 0x07, 0x07}
Colors ["SkyBlue"] = {0x0B, 0x39, 0x54}
Colors ["BloodRed"] = {0xB8, 0x0C, 0x09}
Colors ["SilverMoon"] = {0xFD, 0xFF, 0xFC}
Colors ["LightBlue"] = {0x1F, 0x7A, 0x8C}
Colors ["Silver"] = {0xBF, 0xD7, 0xEA}
Colors ["Black"] = {0, 0, 0}
Colors ["White"] = {255, 255, 255}
Colors ["DarkBlue"] = {0x27, 0x21, 0x3C}
Colors ["DarkRed"] = {0x69, 0x05, 0x00}

return Colors
