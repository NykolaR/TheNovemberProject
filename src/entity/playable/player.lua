-- 
-- player.lua
-- The player!
--

local Class = require ("src.class")

local Player = Class.new ()

Player._tileSize = 16
Player._spriteSheet = love.graphics.newImage ("assets/visual/sprites/player.png")
Player._swordSheet = love.graphics.newImage ("assets/visual/sprites/swords.png")
Player._quads = {}
Player._swordQuads = {}
Player._speed = 60

-- REQUIRED MODULES --

Input = require ("src.boundary.input")
Draw = require ("src.boundary.display.draw")
Rectangle = require ("src.logic.rectangle")
General = require ("src.logic.general")
Quads = require ("src.logic.quads")
Swords = require ("src.entity.playable.swords")

-- END MODULES --

Quads.generateQuads (Player._quads, Player._spriteSheet, Player._tileSize)
Quads.generateQuads (Player._swordQuads, Player._swordSheet, Player._tileSize)

function Player:_init (x, y)
    self.hitbox = Rectangle (x, y, 14, 8)
    self.dir = General.Directions.UP
    self.ori = General.Directions.VERTICAL
    self.weaponDrawn = false
    self.sword = 1
    self.swordFrame = 1
    self.swordSubFrame = 1
    self.swordHitbox = Rectangle (x, y, 16, 16)
end

-- Sets initial variables
function Player:firstInit ()
    self.health = 10
    self.stamina = 3
    self.magic = 5
    self.exp = 0
    self.level = 1
end

-- TODO
function Player:loadFromSave (id)
    self.health = 10
end

-- Update player position, etc
function Player:update (dt)
    self:setDirection ()
    self.hitbox:setLastPosition (self.hitbox.x, self.hitbox.y)

    if not self.weaponDrawn then
        if Input.keyPressed (Input.KEYS.ACTION) then
            self.weaponDrawn = true
        end
    else
        self.swordSubFrame = self.swordSubFrame + 1
        if self.swordSubFrame > Swords [self.sword].TIME then
            self.swordSubFrame = 1
            self.swordFrame = self.swordFrame + 1
        end
        if self.swordFrame > 4 then
            self.swordFrame = 1
            self.swordSubFrame = 1
            self.weaponDrawn = false
        end
    end
    self:setSwordHitbox ()

end

function Player:setDirection ()
    self:setOrientation ()

    if self.ori == General.Directions.HORIZONTAL then
        self:setDirectionVertical ()
        self:setDirectionHorizontal ()
    else
        self:setDirectionHorizontal ()
        self:setDirectionVertical ()
    end
end

function Player:setOrientation ()
    if (self.hitbox.x == self.hitbox.xLast) and not (self.hitbox.y == self.hitbox.yLast) then
        self.ori = General.Directions.VERTICAL
    end

    if (self.hitbox.y == self.hitbox.yLast) and not (self.hitbox.x == self.hitbox.xLast) then
        self.ori = General.Directions.HORIZONTAL
    end
end

function Player:setDirectionHorizontal ()
    if not (self.hitbox.x == self.hitbox.xLast) then
        if self.hitbox.x < self.hitbox.xLast then
            self.dir = General.Directions.LEFT
        else
            self.dir = General.Directions.RIGHT
        end
    end
end

function Player:setDirectionVertical ()
    if not (self.hitbox.y == self.hitbox.yLast) then
        if (self.hitbox.y < self.hitbox.yLast) then
            self.dir = General.Directions.UP
        else
            self.dir = General.Directions.DOWN
        end
    end
end

function Player:updateHorizontal (dt)
    if not self.weaponDrawn then
        self:updateHorizontalMovement (love.timer.getFPS ())
    end
end

function Player:updateVertical (dt)
    if not self.weaponDrawn then
        self:updateVerticalMovement (love.timer.getFPS ())
    end
end

function Player:setSwordHitbox ()
    if self.dir == General.Directions.UP then
        self.swordHitbox.x = self.hitbox.x - 1
        self.swordHitbox.y = self.hitbox.y - 16
    elseif self.dir == General.Directions.RIGHT then
        self.swordHitbox.x = self.hitbox.x + 7
        self.swordHitbox.y = self.hitbox.y - 8
    elseif self.dir == General.Directions.DOWN then
        self.swordHitbox.x = self.hitbox.x - 1
        self.swordHitbox.y = self.hitbox.y
    else
        self.swordHitbox.x = self.hitbox.x - 9
        self.swordHitbox.y = self.hitbox.y - 8
    end
end

function Player:updateHorizontalMovement (fps)
    if Input.keyDown (Input.KEYS.RIGHT) then
        self.hitbox.x = self.hitbox.x + Player._speed / fps
    end

    if Input.keyDown (Input.KEYS.LEFT) then
        self.hitbox.x = self.hitbox.x - Player._speed / fps
    end
end

function Player:updateVerticalMovement (fps)
    if Input.keyDown (Input.KEYS.DOWN) then
        self.hitbox.y = self.hitbox.y + Player._speed / fps
    end

    if Input.keyDown (Input.KEYS.UP) then
        self.hitbox.y = self.hitbox.y - Player._speed / fps
    end
end

-- Draw the player
-- As usual, never perform any logic here
-- Not even animation logic (so if paused the animations stop)
function Player:render ()
    local x,y = math.floor (self.hitbox.x - 1), math.floor (self.hitbox.y - 8)

    love.graphics.draw (Player._spriteSheet, Player._quads [self.dir], x, y)
    if self.weaponDrawn then
        self:renderWeapon ()
    end
end

function Player:renderWeapon ()
    local rotation = 0
    local xPos = 0
    local yPos = 0

    if self.dir == General.Directions.UP then
        rotation = 4.712 -- 90 degrees, ew
        yPos = 8
    elseif self.dir == General.Directions.RIGHT then
        xPos = 8
    elseif self.dir == General.Directions.DOWN then
        yPos = 8
        xPos = 16
        rotation = 1.571
    elseif self.dir == General.Directions.LEFT then
        yPos = 16
        xPos = 8
        rotation = 3.142
    end

    love.graphics.draw (Player._swordSheet, Player._swordQuads [self.swordFrame], self.hitbox.x - 1 + xPos, self.hitbox.y - 8 + yPos, rotation)
end

-- Checks for environmental collision
function Player:environmentCollision (rectangle, direction)
    local check = self.hitbox:collision (rectangle)

    if not check then return end

    if direction == General.Directions.VERTICAL then
        if check [General.Directions.UP] then self.hitbox.y = rectangle.y + rectangle.height end
        if check [General.Directions.DOWN] then self.hitbox.y = rectangle.y - self.hitbox.height end
    end

    if direction == General.Directions.HORIZONTAL then
        if check [General.Directions.LEFT] then self.hitbox.x = rectangle.x + rectangle.width end
        if check [General.Directions.RIGHT] then self.hitbox.x = rectangle.x - self.hitbox.width end
    end
end

function Player:resetX ()
    self.hitbox.resetX ()
end

function Player:resetY ()
    self.hitbox.resetY ()
end

return Player
