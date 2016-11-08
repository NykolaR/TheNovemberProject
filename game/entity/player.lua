-- 
-- player.lua
-- The player!
--


local Player = {}
Player.__index = Player
Player.__width = 16
Player.__height = 16
Player.__spriteSheet = love.graphics.newImage ("resources/player.png")
Player.__quads = {}
Player.__speed = 1

-- REQUIRED MODULES --

Input = require ("game.boundary.input.input")
Draw = require ("game.boundary.display.draw")
Rectangle = require ("game.logic.rectangle")
Constants = require ("game.logic.constants")

-- END MODULES --

for x = 0, 3 do
    table.insert (Player.__quads, love.graphics.newQuad (x * Player.__width, 0, Player.__width, Player.__height, Player.__spriteSheet:getWidth (), Player.__spriteSheet:getHeight ()))
end

-- Constructor
-- Attributes gained: x, y, dir, weaponDrawn
function Player.new (x, y)
    return setmetatable ({hitbox = Rectangle.new (x, y), dir = 1, weaponDrawn = false, ori = 6}, Player)
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
    if not weaponDrawn then
        self:move (dt)
    end
    self.hitbox:setPosition (self.hitbox.x, self.hitbox.y)
end

-- Currently doesn't use dt (to maintain an integer value
-- Maybe change but floor the final position?
-- 4-way movement: if more than 1 dir entered, hori takes priority
function Player:move (dt)
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
    love.graphics.draw (Player.__spriteSheet, Player.__quads [self.dir], self.hitbox.x, self.hitbox.y)
end

-- Checks for environmental collision
function Player:environmentCollisions (rectangle)
    local check = self.hitbox:collision (rectangle)

    if check [Constants.Directions.UP] then self.hitbox:resetY () end
    if check [Constants.Directions.DOWN] then self.hitbox:resetY () end
    if check [Constants.Directions.LEFT] then self.hitbox:resetX () end
    if check [Constants.Directions.RIGHT] then self.hitbox:resetX () end

end

function Player:resetX ()
    self.hitbox.resetX ()
end

function Player:resetY ()
    self.hitbox.resetY ()
end

return Player
