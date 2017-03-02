local Class = require ("src.class")

local Cacti = Class.new ()

Cacti.oState, Cacti.iState = 194, 141
Cacti.top = 47


function Cacti:_init (x, y)
    self.hitbox = Rectangle (x + 2, y, 12, 16)
    self.toppled = false
end

function Cacti:playerInteract (player, direction)
    -- Damage player
    player:environmentCollision (self.hitbox, direction)
end

function Cacti:swordInteract (sword, direction)
    if self.hitbox:intersects (sword) then
        if not self.toppled then
            self.toppled = true
            self.hitbox.x = self.hitbox.x + 3
            self.hitbox.y = self.hitbox.y + 6
            self.hitbox.width = 6
            self.hitbox.height = 8
        end
    end
end

function Cacti:render ()
    if self.toppled then
        Draw.renderTile (Cacti.iState, self.hitbox.x - 4, self.hitbox.y - 6)
    else
        Draw.renderTile (Cacti.oState, self.hitbox.x - 2, self.hitbox.y)
    end

    --self.hitbox:render ()
end

function Cacti:renderTop ()
    if not self.toppled then
        Draw.renderTile (Cacti.top, self.hitbox.x - 2, self.hitbox.y - 16)  
    end
end

return Cacti
