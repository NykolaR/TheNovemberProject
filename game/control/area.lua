-- 
-- area.lua
-- Controls the loading of areas
-- Purely a static class. Only one area is loaded at a time.
-- Areas consist of one screen (20x14 tiles)
--

local Area = {}

Area ["bottom"] = {}
Area ["middle"] = {}
Area ["top"] = {}
Area ["collisions"] = {}
Area ["collisionValues"] = {}

-- REQUIRED MODULES --

local Rectangle = require ("game.logic.rectangle")
local Draw = require ("game.boundary.display.draw")

-- END MODULES --

function Area.loadArea (x, y, z)
    local data, size = love.filesystem.read ("resources/areas/"..z.."/"..x..","..y..".area")

    local dataTable = {}

    for i in string.gmatch (data, "%S+") do
        table.insert (dataTable, i)
    end
    
    for i in data:gmatch ("%d+") do
        table.insert (dataTable, tonumber (i))
    end

    Area.bottom = {}
    Area.middle = {}
    Area.top = {}
    Area.collisions = {}

    for i = 1, #dataTable, 3 do
        table.insert (Area.bottom, tonumber (dataTable [i]))
        table.insert (Area.middle, tonumber (dataTable [i + 1]))
        table.insert (Area.top, tonumber (dataTable [i + 2]))
    end

    for i = 1, #Area.bottom, 1 do
        local temp = Area.bottom [i]
        if Area.middle [i] > Area.bottom [i] then
            temp = Area.middle [i]
        end

        if temp > 130 then
            if temp < 179 then
                table.insert (Area.collisions, Rectangle.new (Area.getX (i), Area.getY (i)))
            end
        end
    end

end

function Area.drawBottom ()
    for i=1, #Area.bottom do
        local x = Area.getX (i)
        local y = Area.getY (i)
        if Area.bottom [i] > 0 then
            Draw.drawTile (Area.bottom [i], x, y)
        end
        if Area.middle [i] > 0 then
            Draw.drawTile (Area.middle [i], x, y)
        end
    end
end

function Area.drawTop ()
    for i=1, #Area.top do
        if Area.top [i] > 0 then
            local x = Area.getX (i)
            local y = Area.getY (i)
            Draw.drawTile (Area.top [i], x, y)
        end
    end
end

function Area.getX (i)
    return ((i - 1) % 20) * 16
end

function Area.getY (i)
    return math.floor (((i - 1) / 20)) * 16
end

function Area.getPositions (i)
    return ((i - 1) % 20) * 16, math.floor (((i - 1) / 20)) * 16
end

function Area.getCollision (x, y)
    -- Derive tile number, then return the collision number
    x = (x - (x % 16)) / 16
    y = (y - (y % 16)) / 16

    -- Index is x + y * 20
    return Area.collisions [x + y * 20] or 0
end

return Area
