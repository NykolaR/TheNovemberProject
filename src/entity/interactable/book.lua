local Class = require ("src.class")

local Book = Class.new ()

local Rectangle = require ("src.logic.rectangle")
local Draw = require ("src.boundary.display.draw")

Book.oState, Book.iState = 196, 113

function Book:_init (x, y)
    self.hitbox = Rectangle (x + 4, y + 2, 8, 12)
    self.toppled = false
end

function Book:playerInteract (player, direction)
    if not self.toppled then
        if self.hitbox:intersects (player.hitbox) then
            self.toppled = true
        end
    end
end

function Book:swordInteract (sword, direction)
end

function Book:render ()
    if self.toppled then
        Draw.renderTile (Book.iState, self.hitbox.x - 4, self.hitbox.y - 2)
    else
        Draw.renderTile (Book.oState, self.hitbox.x - 4, self.hitbox.y - 2)
    end
end

return Book
