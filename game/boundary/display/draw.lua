-- 
-- draw.lua
-- Contains some basic draw functions
-- Made to clean up code in other areas via simplified draw calls
--

local Draw = {}

-- Draw a 16x16 tile to the canvas
function Draw.tile (tile, x, y)
    love.graphics.draw (tile, x * 16, y * 16)
end

return Draw
