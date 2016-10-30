-- 
-- draw.lua
-- Contains some basic draw functions
-- Made to clean up code in other areas via simplified draw calls
--

local Draw = {}
Draw.__tileWidth = 16
Draw.__tileHeight = 16
Draw.__quads = {}
Draw.__tileSet = nil

-- QUADS SET FOR 256 by 256 TEXTUREMAP --
for y = 0, 32 do
    for x = 0, 32 do
        table.insert (Draw.__quads, love.graphics.newQuad (x * Draw.__tileWidth, y * Draw.__tileHeight, Draw.__tileWidth, Draw.__tileHeight, 256, 256))
    end
end

-- Draw a 16x16 tile to the canvas
function Draw.tile (tileIndex, x, y)
    love.graphics.draw (tile, x * 16, y * 16)
end

-- Loads in a tileset and initializes it
-- Test for memory leaks, because depending on GC it might leak
function Draw.loadTileSet (name)
    Draw.__tileSet = love.graphics.newImage (name)
end

-- Draws tile at index at position x,y
function Draw.drawTile (tileIndex, x, y)
    love.graphics.draw (Draw.__tileSet, Draw.__quads [tileIndex], x, y)
end

-- Loads in a static tileset
-- That is, loads a canvas with ALL the tiles
function Draw.loadStaticTiles (file)

end

return Draw
