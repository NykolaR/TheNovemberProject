-- 
-- main.lua
-- Base of the game
-- Runs update and draw functions
-- Controls game scenes
--

local Input = require ("game.boundary.input.input")
local Screen = require ("game.boundary.display.screen")
local PlayerModule = require ("game.entity.player")
local player = PlayerModule.new (16 * 10, 16 * 7)
local stone = love.graphics.newImage ("resources/stone.png")
local stoneShadow = love.graphics.newImage ("resources/stoneshadow.png")
local wall = love.graphics.newImage ("resources/wallmiddle.png")

function love.load ()
    love.graphics.setBackgroundColor (0,0,0)
    Screen.init ()
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
    Screen.clear ({255, 255, 255})

    for x = 0, 20, 1 do
        for y = 0, 14, 1 do
            if x == 6 then
                love.graphics.draw (wall, x*16,y*16,0,1,1)
            elseif x == 7 then
                love.graphics.draw (stoneShadow, x*16,y*16,0,1,1)
            elseif x == 13 then
                love.graphics.draw (wall, x*16,y*16,0,1,1)
            elseif x == 14 then
                love.graphics.draw (stoneShadow, x*16,y*16,0,1,1)
            else
                love.graphics.draw (stone, x * 16, y * 16, 0, 1, 1)
            end
        end
    end
    
    player:draw ()

    Screen.endDraw ()
    Screen.drawScreen ()
end

function logFPS ()
    love.graphics.setColor (255, 255, 255)
    love.graphics.print ("FPS: " .. tostring (love.timer.getFPS ()), 15, 15)
end
