-- 
-- main.lua
-- Base of the game
-- Runs update and draw functions
-- Controls game scenes
--

-- MODULES REQUIRED --

local Input = require ("src.boundary.input")
local Screen = require ("src.boundary.display.screen")
local PlayArea = require ("src.control.playarea")
local MainMenu = require ("src.control.mainmenu")
local Settings = require ("src.control.settings")

local font = love.graphics.newImageFont ("assets/visual/font.png",
    " abcdefghijklmnopqrstuvwxyz0123456789", 1)
love.graphics.setFont (font)

-- END MODULES --

local playArea = PlayArea ()
local mainMenu = MainMenu ()

function love.load ()
    love.mouse.setVisible (false)
    love.math.setRandomSeed (os.time ())

    Screen.init ()
    playArea:init ()
end

function love.update (dt)
    Input.handleInputs () -- Update input handler
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end

    if mainMenu.gamestart then
        playArea:update (dt)
    else
        mainMenu:update (dt)
    end
end

function love.draw ()
    Screen.beginRender ()
    love.graphics.setBlendMode ("alpha", "alphamultiply")
    
    -- PERFORM RENDERING TO CANVAS
    --Screen.clear ({10, 10, 10})  -- Don't /need/ because screen is always drawn over

    if mainMenu.gamestart then
        playArea:render ()
    else
        mainMenu:render ()
    end

    -- TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO --
    -- REMOVE ON RELEASE --
    if Settings.debug then 
        logFPS ()
    end

    Screen.endRender ()

    love.graphics.setBlendMode ("alpha", "premultiplied")
    Screen.render ()
end

function logFPS ()
    love.graphics.setColor (255, 255, 255)
    --Text.string ("FPS " .. tostring (love.timer.getFPS ()), 15, 15)
    love.graphics.print ("FPS " .. tostring (love.timer.getFPS ()), 15, 15)
end
