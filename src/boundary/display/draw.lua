-- 
-- draw.lua
-- Contains some basic draw functions
-- Made to clean up code in other areas via simplified draw calls
--

local Draw = {}
Draw.__tilesize = 16
Draw.__quads = {}
Draw.__tileSet = love.graphics.newImage ("assets/visual/tiles/tilest.png")
Draw.__numTiles = (Draw.__tileSet:getWidth () / 16 - 1) * (Draw.__tileSet:getHeight () / 16 - 1)

-- REQUIRED MODULES --

local Quads = require ("src.logic.quads")

-- END MODULES --

-- QUADS SET FOR TILESHEET ABOVE --
Quads.generateQuads (Draw.__quads, Draw.__tileSet, Draw.__tilesize)

-- Draw a 16x16 tile to the canvas
function Draw.tile (tileIndex, x, y)
    love.graphics.draw (tile, x * 16, y * 16)
end

-- Loads in a tileset and initializes it
-- Test for memory leaks, because depending on GC it might leak
-- Probably shouldn't really be called...
function Draw.loadTileSet (name)
    Draw.__tileSet = love.graphics.newImage (name)
end

-- Draws tile at index at position x,y
function Draw.renderTile (tileIndex, x, y)
    love.graphics.draw (Draw.__tileSet, Draw.__quads [tileIndex], x, y)
end

-- Loads in a static tileset
-- That is, loads a canvas with ALL the tiles
function Draw.loadStaticTiles (file)

end

return Draw
