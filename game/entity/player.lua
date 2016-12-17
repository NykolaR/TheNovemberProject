-- 
-- player.lua
-- The player!
--


local Player = {}
Player.__index = Player
Player.__tileSize = 16
Player.__spriteSheet = love.graphics.newImage ("resources/player.png")
Player.__swordSheet = love.graphics.newImage ("resources/swords.png")
Player.__quads = {}
Player.__swordQuads = {}
Player.__speed = 1

setmetatable (Player, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- REQUIRED MODULES --

Input = require ("game.boundary.input.input")
Draw = require ("game.boundary.display.draw")
Rectangle = require ("game.logic.rectangle")
Constants = require ("game.logic.constants")
Quads = require ("game.logic.quads")
Swords = require ("game.entity.swords")

-- END MODULES --

Quads.generateQuads (Player.__quads, Player.__spriteSheet, Player.__tileSize)
Quads.generateQuads (Player.__swordQuads, Player.__swordSheet, Player.__tileSize)

function Player:_init (x, y)
    self.hitbox = Rectangle (x, y, 14, 8)
    self.dir = 1
    self.weaponDrawn = false
    self.ori = 6
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
    self.hitbox:setLastPosition (self.hitbox.x, self.hitbox.y)


    if not self.weaponDrawn then
        self:move (dt)
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
    self.hitbox:setPosition (self.hitbox.x, self.hitbox.y)
    self:setSwordHitbox ()
end

function Player:setSwordHitbox ()
    if self.dir == Constants.Directions.UP then
        self.swordHitbox.x = self.hitbox.x - 1
        self.swordHitbox.y = self.hitbox.y - 16
    elseif self.dir == Constants.Directions.RIGHT then
        self.swordHitbox.x = self.hitbox.x + 7
        self.swordHitbox.y = self.hitbox.y - 8
    elseif self.dir == Constants.Directions.DOWN then
        self.swordHitbox.x = self.hitbox.x - 1
        self.swordHitbox.y = self.hitbox.y
    else
        self.swordHitbox.x = self.hitbox.x - 9
        self.swordHitbox.y = self.hitbox.y - 8
    end
end

-- Currently doesn't use dt (to maintain an integer value
-- Maybe change but floor the final position?
-- 4-way movement: if more than 1 dir entered, hori takes priority
function Player:move (dt)
    self:fourDirMove (dt)
end

function Player:fourDirMove (dt)
    local vert = (Input.keyDown (Input.KEYS.UP) or Input.keyDown (Input.KEYS.DOWN))

    if vert then
        if not (Input.keyDown (Input.KEYS.UP) and Input.keyDown (Input.KEYS.DOWN)) then
            if Input.keyDown (Input.KEYS.UP) then
                self.dir = Constants.Directions.UP
                self.ori = Constants.Directions.VERTICAL
                self.hitbox.y = self.hitbox.y - Player.__speed
            elseif Input.keyDown (Input.KEYS.DOWN) then
                self.dir = Constants.Directions.DOWN
                self.ori = Constants.Directions.VERTICAL
                self.hitbox.y = self.hitbox.y + Player.__speed
            end
        end
    else
        if not (Input.keyDown (Input.KEYS.RIGHT) and Input.keyDown (Input.KEYS.LEFT)) then
            if Input.keyDown (Input.KEYS.RIGHT) then
                self.dir = Constants.Directions.RIGHT
                self.ori = Constants.Directions.HORIZONTAL
                self.hitbox.x = self.hitbox.x + Player.__speed
            elseif Input.keyDown (Input.KEYS.LEFT) then
                self.dir = Constants.Directions.LEFT
                self.ori = Constants.Directions.HORIZONTAL
                self.hitbox.x = self.hitbox.x - Player.__speed
            end
        end
    end
end

function Player:eightDirMove (dt)
    local hori = (Input.keyDown (Input ["KEYS"].LEFT) or Input.keyDown (Input ["KEYS"].RIGHT))
    local vert = (Input.keyDown (Input ["KEYS"].UP) or Input.keyDown (Input ["KEYS"].DOWN))

    --
    if hori and (self.hitbox.y == self.hitbox.yLast) then
        if self.hitbox.x > self.hitbox.xLast then
            self.dir = Constants.Directions.RIGHT
            self.ori = Constants.Directions.HORIZONTAL
        elseif self.hitbox.x < self.hitbox.xLast then
            self.dir = Constants.Directions.LEFT
            self.ori = Constants.Directions.HORIZONTAL
        end
    end

    if vert and (self.hitbox.x == self.hitbox.xLast) then
        if self.hitbox.y > self.hitbox.yLast then
            self.dir = Constants.Directions.DOWN
            self.ori = Constants.Directions.VERTICAL
        elseif self.hitbox.y < self.hitbox.yLast then
            self.dir = Constants.Directions.UP
            self.ori = Constants.Directions.VERTICAL
        end
    end

    if hori then
        if Input.keyDown (Input ["KEYS"].LEFT) then
            self.hitbox.x = self.hitbox.x - Player.__speed
            if not vert then
                if not Input.keyDown (Input ["KEYS"].RIGHT) then
                    self.dir = Constants.Directions.LEFT
                    self.ori = Constants.Directions.HORIZONTAL
                end
            end
        end

        if Input.keyDown (Input ["KEYS"].RIGHT) then
            self.hitbox.x = self.hitbox.x + Player.__speed
            if not vert then
                if not Input.keyDown (Input ["KEYS"].LEFT) then
                    self.dir = Constants.Directions.RIGHT
                    self.ori = Constants.Directions.HORIZONTAL
                end
            end
        end
    end

    if vert then
        if Input.keyDown (Input ["KEYS"].UP) then
            self.hitbox.y = self.hitbox.y - Player.__speed
            if not hori then
                if not Input.keyDown (Input ["KEYS"].DOWN) then
                    self.dir = Constants.Directions.UP
                end
            end
        end

        if Input.keyDown (Input ["KEYS"].DOWN) then
            self.hitbox.y = self.hitbox.y + Player.__speed
            if not hori then
                if not Input.keyDown (Input ["KEYS"].UP) then
                    self.dir = Constants.Directions.DOWN
                end
            end
        end
    end
end

-- Draw the player
-- As usual, never perform any logic here
-- Not even animation logic (so if paused the animations stop)
function Player:draw ()
    love.graphics.draw (Player.__spriteSheet, Player.__quads [self.dir], self.hitbox.x - 1, self.hitbox.y - 8)
    if self.weaponDrawn then
        self:drawWeapon ()
    end
end

function Player:drawWeapon ()
    local rotation = 0
    local xPos = 0
    local yPos = 0

    if self.dir == Constants.Directions.UP then
        rotation = 4.712 -- 90 degrees, ew
        yPos = 8
    elseif self.dir == Constants.Directions.RIGHT then
        xPos = 8
    elseif self.dir == Constants.Directions.DOWN then
        yPos = 8
        xPos = 16
        rotation = 1.571
    elseif self.dir == Constants.Directions.LEFT then
        yPos = 16
        xPos = 8
        rotation = 3.142
    end

    love.graphics.draw (Player.__swordSheet, Player.__swordQuads [self.swordFrame], self.hitbox.x - 1 + xPos, self.hitbox.y - 8 + yPos, rotation)
end

-- Checks for environmental collision
function Player:environmentCollisions (rectangle)
    local check = self.hitbox:collision (rectangle)

    if check [Constants.Directions.UP] then self.hitbox.y = rectangle.y + rectangle.height end
    if check [Constants.Directions.DOWN] then self.hitbox.y = rectangle.y - self.hitbox.height end
    if check [Constants.Directions.LEFT] then self.hitbox.x = rectangle.x + rectangle.width end
    if check [Constants.Directions.RIGHT] then self.hitbox.x = rectangle.x - self.hitbox.width end
end

function Player:resetX ()
    self.hitbox.resetX ()
end

function Player:resetY ()
    self.hitbox.resetY ()
end

return Player
