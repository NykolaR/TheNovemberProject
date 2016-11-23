-- 
-- quads.lua
-- Constains quad functions

local Quads = {}

-- Generates quads for a tilesheet
-- Args: table to store quads, tilesheet image, tile size
function Quads.generateQuads (quadTable, image, tilesize)
    for y = 0, (image:getHeight () / tilesize - 1) do
        for x = 0, (image:getWidth () / tilesize - 1) do
            table.insert (quadTable, love.graphics.newQuad (x * tilesize, y * tilesize, tilesize, tilesize, image:getWidth (), image:getHeight ()))
        end
    end
end

return Quads
