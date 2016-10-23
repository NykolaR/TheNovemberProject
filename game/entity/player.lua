-- 
-- player.lua
-- The player!
--

Input = require ("game.boundary.input.input")
Draw = require ("game.boundary.display.draw")

local Player = {}
Player.__index = Player
Player.__width = 24
Player.__height = 24
Player.__img = love.graphics.newImage ("resources/player.png")

function Player.new (x, y)
    return setmetatable ({x = x or 0, y = y or 0}, Player)
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
    self.x = self.x
end

-- Draw the player
function Player:draw ()
    love.graphics.draw (Player.__img, self.x, self.y)
end

return Player
