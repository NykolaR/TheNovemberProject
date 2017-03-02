-- 
-- area.lua
-- Controls the loading of areas
-- Purely a static class. Only one area is loaded at a time.
-- Areas consist of one screen (20x14 tiles)
--
-- TODO TODO Make it load in tiled files actually well TODO TODO
--

local Area = {}

Area.bottom = {}
Area.middle = {}
Area.top = {}
Area.collisions = {}

-- REQUIRED MODULES --

local Rectangle = require ("src.logic.rectangle")
local Draw = require ("src.boundary.display.draw")

-- END MODULES --

local _width, _height, _tilesize = 0, 0, 0

function Area.loadArea (x, y, z)
    local data = require ("assets.areas."..z.."."..x..","..y)

    _width, _height = data.width, data.height
    _tilesize = data.tilewidth

    Area.bottom = {}
    Area.middle = {}
    Area.top = {}

    for i = 1, (_width * _height) do
        table.insert (Area.bottom, data.layers [1].data [i])
        table.insert (Area.middle, data.layers [2].data [i])
        table.insert (Area.top, data.layers [3].data [i])
    end

    Area.collisions = {}

    for i = 1, #Area.bottom do
        if data.layers [4].data [i] > 1 then
            table.insert (Area.collisions, Rectangle (Area.getX (i - 1), Area.getY (i - 1), _tilesize, _tilesize))
        end
    end
end

function Area.renderBottom ()
    local index = 1

    for y=0, _height - 1 do
        for x=0, _width - 1 do
            local drawX, drawY = x * _tilesize, y * _tilesize

            if not (Area.bottom [index] == 0) then
                Draw.renderTile (Area.bottom [index], drawX, drawY)
            end

            if not (Area.middle [index] == 0) then
                Draw.renderTile (Area.middle [index], drawX, drawY)
            end

            index = index + 1
        end
    end
end

function Area.renderTop ()
    local index = 1

    for y=0, _height - 1 do
        for x=0, _width - 1 do
            if not (Area.top [index] == 0) then
                Draw.renderTile (Area.top [index], x * _tilesize, y * _tilesize)
            end

            index = index + 1
        end
    end
end

function Area.getX (index)
    return (index % _width) * _tilesize
end

function Area.getY (index)
    return math.floor (index / _width) * _tilesize
end

function Area.getPositions (index)
    return Area.getX (index), Area.getY (index)
end

--[[
function Area.getCollision (x, y)
    -- Derive tile number, then return the collision number
    x = (x - (x % 16)) / 16
    y = (y - (y % 16)) / 16

    -- Index is x + y * 20
    return Area.collisions [x + y * 20] or 0
end
]]

return Area
