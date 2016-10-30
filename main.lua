-- 
-- main.lua
-- Base of the game
-- Runs update and draw functions
-- Controls game scenes
--

local Input = require ("game.boundary.input.input")
local Screen = require ("game.boundary.display.screen")
local Draw = require ("game.boundary.display.draw")
local Text = require ("game.boundary.display.text")
local Area = require ("game.control.area")
local PlayerModule = require ("game.entity.player")
local player = PlayerModule.new (0,0)

function love.load ()
    love.graphics.setBackgroundColor (0,0,0)
    Screen.init ()
    Draw.loadTileSet ("resources/stoneTiles.png")
    Area.loadArea ("castle", 0, 0)
end

function love.update (dt)
    Input.handleInputs () -- Update input handler
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end
    player:update (dt)
end

function love.draw ()
    Screen.beginDraw ()
    
    -- PERFORM RENDERING TO CANVAS
    Screen.clear ({10, 10, 10})

    Area.drawBottom () 
    player:draw ()
    Area.drawTop ()

    Screen.endDraw ()
    Screen.drawScreen ()
end

function logFPS ()
    love.graphics.setColor (255, 255, 255)
    love.graphics.print ("FPS: " .. tostring (love.timer.getFPS ()), 15, 15)
end
