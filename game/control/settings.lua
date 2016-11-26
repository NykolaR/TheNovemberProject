-- settings.lua
-- Contains game settings
-- Maybe read from a file for stored settings (?)
--

local Settings = {}

-- Preferably read in from a file, and write to a file
-- if (settingsfile exists) then
--      LOAD SETTINGS
-- else then
Settings.particles = true
Settings.debug = false
Settings.HUDmode = true

function Settings.saveSettings ()
    -- TODO
    -- Save settings
end

return Settings
