-- 
-- main.lua
-- Base of the game
-- Runs update and draw functions
-- Controls game scenes
--

local Input = require ("game.boundary.input.input")
local Screen = require ("game.boundary.display.screen")

function love.load ()
    love.graphics.setBackgroundColor (0,0,0)
    Screen.init ()
end

function love.update (dt)
    Input.handleInputs () -- Update input handler
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end
end

function love.draw ()
    Screen.beginDraw ()
    
    -- PERFORM RENDERING TO CANVAS
    
    Screen.clear ({255, 255, 255})

    Screen.endDraw ()

    Screen.drawScreen ()

end

function logFPS ()
    love.graphics.setColor (255, 255, 255)
    love.graphics.print ("FPS: " .. tostring (love.timer.getFPS ()), 15, 15)
end
