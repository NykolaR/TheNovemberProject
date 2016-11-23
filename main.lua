-- 
-- main.lua
-- Base of the game
-- Runs update and draw functions
-- Controls game scenes
--

-- MODULES REQUIRED --

local Input = require ("game.boundary.input.input")
local Screen = require ("game.boundary.display.screen")
local PlayArea = require ("game.control.playarea")
local Settings = require ("game.control.settings")

-- END MODULES --

if Settings.debug then Text = require ("game.boundary.display.text") end

local img = love.graphics.newImage ("img.png")
local psystem = love.graphics.newParticleSystem (img, 10)


local playArea = PlayArea.new ()

function love.load ()
    love.graphics.setBackgroundColor (0,0,0)
    Screen.init ()
    playArea:init ()

    -- Particleslol
    psystem:setParticleLifetime (1, 3)
    psystem:setEmissionRate (5)
    psystem:setSizes (1, 0)
    psystem:setSizeVariation (1)
    psystem:setLinearAcceleration (-1, -1, 1, -1)
    psystem:setColors (255, 100, 0, 255, 255, 255, 0, 255)
end

function love.update (dt)
    Input.handleInputs () -- Update input handler
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end
    playArea:update (dt)
    
    psystem:update (dt)
end

function love.draw ()
    Screen.beginDraw ()
    love.graphics.setBlendMode ("alpha", "alphamultiply")
    
    -- PERFORM RENDERING TO CANVAS
    --Screen.clear ({10, 10, 10})  -- Don't /need/ because screen is always drawn over

    playArea:draw ()

    love.graphics.draw (psystem, 156, 156)
    love.graphics.draw (psystem, 100, 100)
    love.graphics.draw (psystem, 150, 100)

    -- TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO --
    -- REMOVE ON RELEASE --
    if Settings.debug then logFPS () end

    Screen.endDraw ()

    love.graphics.setBlendMode ("alpha", "premultiplied")
    Screen.drawScreen ()
end

function logFPS ()
    love.graphics.setColor (255, 255, 255)
    Text.string ("FPS " .. tostring (love.timer.getFPS ()), 15, 15)
end
