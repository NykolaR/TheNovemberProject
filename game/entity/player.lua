-- 
-- player.lua
-- The player!
--

Input = require ("game.boundary.input.input")
Draw = require ("game.boundary.display.draw")

local Player = {}
Player.__index = Player
Player.__width = 16
Player.__height = 16
Player.__spriteSheet = love.graphics.newImage ("resources/player.png")
Player.__quads = {}

for x = 0, 3 do
    table.insert (Player.__quads, love.graphics.newQuad (x * Player.__width, 0, Player.__width, Player.__height, Player.__spriteSheet:getWidth (), Player.__spriteSheet:getHeight ()))
end

-- Constructor
-- Attributes gained: x, y, dir, weaponDrawn
function Player.new (x, y)
    return setmetatable ({x = x or 0, y = y or 0, dir = 1, weaponDrawn = false}, Player)
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
    if not weaponDrawn then
        self:move (dt)
    end
end

-- Currently doesn't use dt (to maintain an integer value
-- Maybe change but floor the final position?
-- 4-way movement: if more than 1 dir entered, hori takes priority
function Player:move (dt)
    if Input.keyDown (Input ["KEYS"].LEFT) or Input.keyDown (Input ["KEYS"].RIGHT) then
        if Input.keyDown (Input ["KEYS"].LEFT) then
            self.x = self.x - 1
            if not Input.keyDown (Input ["KEYS"].RIGHT) then
                self.dir = 3
            end
        end

        if Input.keyDown (Input ["KEYS"].RIGHT) then
            self.x = self.x + 1
            if not Input.keyDown (Input ["KEYS"].LEFT) then
                self.dir = 4
            end
        end

        return
    end

    if Input.keyDown (Input ["KEYS"].UP) then
        self.y = self.y - 1
        if not Input.keyDown (Input ["KEYS"].DOWN) then
            self.dir = 1
        end
    end

    if Input.keyDown (Input ["KEYS"].DOWN) then
        self.y = self.y + 1
        if not Input.keyDown (Input ["KEYS"].UP) then
            self.dir = 2
        end
    end
end

-- Draw the player
-- As usual, never perform any logic here
-- Not even animation logic (so if paused the animations stop)
function Player:draw ()
    love.graphics.draw (Player.__spriteSheet, Player.__quads [self.dir], self.x, self.y)
end

return Player
