--
-- mainmenu.lua
-- The main menu
-- Can control settings and do other neat things
--

local Class = require ("src.class")

local MainMenu = Class.new ()

MainMenu.__quads = {}
MainMenu.__tileSheet = love.graphics.newImage ("assets/visual/sprites/title.png")
MainMenu.__animSpeed = 40

-- REQUIRED MODULES --

local Quads = require ("src.logic.quads")

-- END MODULES --

Quads.generateQuads (MainMenu.__quads, MainMenu.__tileSheet, 320, 224)

function MainMenu:_init ()
    self.selection = 0
    self.submenu = 0
    self.frame = 1
    self.subframe = 1
end

function MainMenu:update (dt)
    self.subframe = self.subframe + 1
    if self.subframe > MainMenu.__animSpeed then
        self.frame = self.frame + 1
        if self.frame > 4 then
            self.frame = 1
        end
        self.subframe = 1
    end

    if (Input.keyDown (Input.KEYS.PAUSED)) then
        self.gamestart = true
    end
end

function MainMenu:render ()
    love.graphics.draw (MainMenu.__tileSheet, MainMenu.__quads [self.frame], 0, 0)
    love.graphics.print ("PRESS START", 20, 180)
end

return MainMenu
