-- playarea.lua
-- Maintains a play area
-- Controls player and enemy movement
-- Weapon movement
-- Player and enemy collisions
--

local Class = require ("src.class")

local PlayArea = Class.new ()

-- MODULES REQUIRED --

local Draw = require ("src.boundary.display.draw")
local Area = require ("src.control.area")
local Screen = require ("src.boundary.display.screen")
local PlayerModule = require ("src.entity.playable.player")

-- END MODULES --

function PlayArea:_init ()
    self.player = PlayerModule (10 * 16, 10 * 16)
    self.enemies = {}
    self.playerWeapons = {}
    self.enemyWeapons = {}
    self.mapX = 15
    self.mapY = 15
    self.mapZ = 5
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
    -- Updates
    self:playerUpdate ()

    -- Check boarders
    self:checkBorders ()
end

function PlayArea:playerUpdate ()
    self.player:update (dt)

    self.player:updateHorizontal (dt)
    for _,area in pairs (Area.collisions) do
        self.player:environmentCollision (area, General.Directions.HORIZONTAL)
    end

    self.player:updateVertical (dt)
    for _,area in pairs (Area.collisions) do
        self.player:environmentCollision (area, General.Directions.VERTICAL)
    end
end

-- Draw
-- Calls all rendering functions
-- No updates (no variable changes)
function PlayArea:render ()
    -- If time is frozen, don't render Area
    Area.renderBottom ()
    self.player:render ()
    Area.renderTop ()
end

-- Check if player has crossed any borders
-- If yes, change co-ordinates appropriately and load new area
function PlayArea:checkBorders ()
    if self.player.hitbox.x < -8 then
        self.player.hitbox.x = self.player.hitbox.x + Screen.__width
        self.mapX = self.mapX - 1
        Area.loadArea (self.mapX, self.mapY, self.mapZ)
        return
    end
    if self.player.hitbox.x > (Screen.__width - 8) then
        self.player.hitbox.x = self.player.hitbox.x - Screen.__width
        self.mapX = self.mapX + 1
        Area.loadArea (self.mapX, self.mapY, self.mapZ)
        return
    end

    if self.player.hitbox.y < -8 then
        self.player.hitbox.y = self.player.hitbox.y + Screen.__height
        self.mapY = self.mapY - 1
        Area.loadArea (self.mapX, self.mapY, self.mapZ)
        return
    end
    if self.player.hitbox.y > (Screen.__height - 8) then
        self.player.hitbox.y = self.player.hitbox.y - Screen.__height
        self.mapY = self.mapY + 1
        Area.loadArea (self.mapX, self.mapY, self.mapZ)
        return
    end

end

return PlayArea
