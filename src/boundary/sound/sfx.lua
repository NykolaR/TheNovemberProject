-- sfx.lua
-- Controls game sfx
-- Is quite the big guy
--

local SFX = {}
SFX.__index = SFX
SFX.__volume = .6
SFX.__defaultPitch = 1

-- Constructor
function SFX.new (title)
   return setmetatable ({
       file = love.audio.newSource ("resources/sound/sfx/"..title..".ogg", "static")
        },
        SFX)
end

function SFX:play ()
    file:play ()
end

function SFX:setVolume (newVolume)
    local newVol = newVolume or SFX.__volume
    file:setVolume (newVol)
end

return SFX
