-- playarea.lua
-- Maintains a play area
-- Controls player and enemy movement
-- Weapon movement
-- Player and enemy collisions
--

local PlayArea = {}
PlayArea.__index = PlayArea

-- MODULES REQUIRED --

local Draw = require ("game.boundary.display.draw")
local Area = require ("game.control.area")
local Screen = require ("game.boundary.display.screen")
local PlayerModule = require ("game.entity.player")

-- END MODULES --

-- Contructor
function PlayArea.new ()
    return setmetatable ({
    player = PlayerModule.new (48, 48),
    enemies = {},
    playerWeapons = {},
    enemyWeapons = {},
    mapX = 15,
    mapY = 15,
    mapZ = 5,
    }, PlayArea)
end

-- A new game
function PlayArea:init ()
    Area.loadArea (self.mapX, self.mapY, self.mapZ)
end

-- Load game from file
function PlayArea:loadFromFile (filename)
    -- TODO
end

-- Update
-- Calls updates on all entities
-- Also does collisions
-- No rendering
function PlayArea:update (dt)

    -- Movement
    self.player:update (dt)

    -- Collision checks
    for i,v in pairs (Area.collisions) do
        self.player:environmentCollisions (v)
    end

    -- Check boarders
    self:checkBoarders ()
end

-- Draw
-- Calls all rendering functions
-- No updates (no variable changes)
function PlayArea:draw ()
    Area.drawBottom ()
    self.player:draw ()
    Area.drawTop ()
end

-- Check if player has crossed any borders
-- If yes, change co-ordinates appropriately and load new area
function PlayArea:checkBoarders ()
    if self.player.hitbox.x < -8 then
        self.player.hitbox.x = self.player.hitbox.x + Screen.__width
        self.mapX = self.mapX - 1
        Area.loadArea (self.area, self.mapX, self.mapY)
        return
    end
    if self.player.hitbox.x > (Screen.__width - 8) then
        self.player.hitbox.x = self.player.hitbox.x - Screen.__width
        self.mapX = self.mapX + 1
        Area.loadArea (self.area, self.mapX, self.mapY)
        return
    end

    if self.player.hitbox.y < -8 then
        self.player.hitbox.y = self.player.hitbox.y + Screen.__height
        self.mapY = self.mapY - 1
        Area.loadArea (self.area, self.mapX, self.mapY)
        return
    end
    if self.player.hitbox.y > (Screen.__height - 8) then
        self.player.hitbox.y = self.player.hitbox.y - Screen.__height
        self.mapY = self.mapY + 1
        Area.loadArea (self.area, self.mapX, self.mapY)
        return
    end

end

return PlayArea
