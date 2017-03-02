-- music.lua
-- Controls game music
-- Is quite the lil guy
--

local Music = {}
Music.__volume = .6
Music.__defaultPitch = 1

-- 
-- loadMusic (title)
-- Loads the arg into Music.__file
-- Filename format example: "titletheme"
function Music.loadMusic (title)
    if not title then return end

    if Music.__file then
        Music.__file:stop ()
    end
    Music.__file = love.audio.newSource ("resources/sound/music/"..title..".ogg")
    Music.__file:setLooping (true)
end

function Music.play ()
    if Music.__file then
        Music.__file:setVolume (Music.__volume)
        Music.__file:play ()
    end
end

function Music.stop ()
    if Music.__file then
        Music.__file:stop ()
    end
end

function Music.pause ()
    if Music.__file then
        Music.__file:pause ()
    end
end

function Music.resume ()
    if Music.__file then
        Music.__file:resume ()
    end
end

function Music.setVolume (newVolume)
    if Music.__file then
        local newVol = newVolume or Music.__volume
        Music.__file:setVolume (newVol)
    end
end

return Music
