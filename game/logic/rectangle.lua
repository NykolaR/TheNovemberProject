-- rectangle.lua
-- Contains rectangle information and functions
--

local Rectangle = {}
Rectangle.__index = Rectangle

setmetatable (Rectangle, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- REQUIRED MODULES --

local Constants = require ("game.logic.constants")

-- END MODULES --

function Rectangle:_init (x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.xLast = x or 0
    self.yLast = y or 0
    self.width = width or 16
    self.height = height or 16
end

-- Sets position
-- Call after movement in update
function Rectangle:setPosition (x, y)
    self.x = x
    self.y = y
end

-- Sets last position
-- Call before movement in update
function Rectangle:setLastPosition (x, y)
    self.xLast = x
    self.yLast = y
end

-- Returns whether there was a collision with the arg rectangle
-- Also returns which direction collided in a table
function Rectangle:collision (rectangle)
    local ret = {false, false, false, false}
    --[[
    -- 1 = up
    -- 2 = right
    -- 3 = down
    -- 4 = left
    --]]

    ret [Constants.Directions.UP] = self:collidedTop (rectangle)
    ret [Constants.Directions.RIGHT] = self:collidedRight (rectangle)
    ret [Constants.Directions.DOWN] = self:collidedBottom (rectangle)
    ret [Constants.Directions.LEFT] = self:collidedLeft (rectangle)

    return ret
end

function Rectangle:collidedTop (rectangle)
    if ( (self.x > (rectangle.x - self.width)) and (self.x < rectangle.x + rectangle.width) ) then
        return (   (self.yLast >= (rectangle.y + rectangle.height))   and   (self.y <= (rectangle.y + rectangle.height))   )
    end
    return false
end

function Rectangle:collidedRight (rectangle)
    if ((self.y > (rectangle.y - self.height)) and (self.y < rectangle.y + rectangle.height)) then
        return (   ((self.xLast + self.width) <= rectangle.x)   and    ((self.x + self.width) >= rectangle.x)   )
    end
    return false
end

function Rectangle:collidedBottom (rectangle)
    if ((self.x > (rectangle.x - self.width)) and (self.x < rectangle.x + rectangle.width)) then
        return (   ((self.yLast + self.height) <= rectangle.y)   and   ((self.y + self.height) >= rectangle.y)   )
    end
    return false
end

function Rectangle:collidedLeft (rectangle)
    if ( (self.y > (rectangle.y - self.height)) and (self.y < rectangle.y + rectangle.height) ) then
        return (   (self.xLast >= (rectangle.x + rectangle.width))   and   (self.x <= (rectangle.x + rectangle.width))   )
    end
    return false
end

function Rectangle:resetX ()
    self.x = self.xLast
end

function Rectangle:resetY ()
    self.y = self.yLast
end

function Rectangle:draw ()
    love.graphics.setColor ({255, 0, 0, 64})
    love.graphics.rectangle ("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor ({255, 255, 255})
end

return Rectangle
