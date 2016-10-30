-- 
-- screen.lua
-- Contains the canvas used for rendering
-- Size: 10:7, 32x32
-- Format: RGBA8 (8 bits per color, AKA 2 hex per color)
-- Colors defined in the "Colors" package
--

local Screen = {}
if love.graphics.getCanvasFormats ().rgba8 then
    Screen ["canvas"] = love.graphics.newCanvas (10 * 32, 7 * 32, "rgba8")
    Screen.canvas:setFilter ("nearest", "nearest")
else
    print ("Err: RGBA8 Not Supported")
    love.event.quit ()
end
Screen.mult = 1
Screen.drawX = (love.graphics.getWidth () - Screen.canvas:getWidth ()) / 2
Screen.drawY = (love.graphics.getHeight () - Screen.canvas:getHeight ()) / 2


-- Initialize the screen/canvas to be oriented correctly
function Screen.init ()
    while ((Screen.mult + 1) * Screen.canvas:getWidth ()) < love.graphics.getWidth () and ((Screen.mult + 1) * Screen.canvas:getHeight ()) < love.graphics.getHeight () do
        Screen.mult = Screen.mult + 1
    end

    Screen.drawX = (love.graphics.getWidth () - Screen.canvas:getWidth () * Screen.mult) / 2
    Screen.drawY = (love.graphics.getHeight () - Screen.canvas:getHeight () * Screen.mult) / 2
end

-- Clear canvas to black
function Screen.clearBlack ()
    love.graphics.clear ({0, 0, 0})
end

-- Clear canvas to color
function Screen.clear (color)
    if color then
        love.graphics.clear (color)
    else
        Screen.clearBlack ()
    end
end

-- Begin rendering to the canvas
function Screen.beginDraw ()
    love.graphics.setCanvas (Screen.canvas)
end

-- End rendering to the canvas
function Screen.endDraw ()
    love.graphics.setCanvas ()
end

-- Draw canvas centered on screen
function Screen.drawScreen ()
    love.graphics.setBlendMode ("alpha", "premultiplied")
    love.graphics.draw (Screen.canvas, Screen.drawX, Screen.drawY, 0, Screen.mult, Screen.mult)
end

return Screen
