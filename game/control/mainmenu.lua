--
-- mainmenu.lua
-- The main menu
-- Can control settings and do other neat things
--

local MainMenu = {}
MainMenu.__index = MainMenu
MainMenu.__quads = {}
MainMenu.__tileSheet = love.graphics.newImage ("resources/title.png")
MainMenu.__animSpeed = 40

-- REQUIRED MODULES --

local Quads = require ("game.logic.quads")
local Text = require ("game.boundary.display.text")

-- END MODULES --

Quads.generateQuads (MainMenu.__quads, MainMenu.__tileSheet, 320, 224)

function MainMenu.new ()
    return setmetatable ({
        selection = 0,
        submenu = 0,
        frame = 1,
        subframe = 1
    }, MainMenu)
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

function MainMenu:draw ()
    love.graphics.draw (MainMenu.__tileSheet, MainMenu.__quads [self.frame], 0, 0)
    Text.string ("PRESS START", 20, 180)
end

return MainMenu
