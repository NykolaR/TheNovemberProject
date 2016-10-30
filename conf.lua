-- 
-- conf.lua
-- Configures the window and game
-- Disables unused modules to increase performance and load time
--

function love.conf (t)
    -- Set window configurations
    -- This includes calculating the resolution for the game
    
    t.window.title = "The November Project"
    t.window.fullscreentype = "desktop"
    t.window.fullscreen = true

    t.window.minWidth = 10 * 32
    t.window.minHeight = 7 * 32

    -- Disable joystick, mouse
    t.modules.joystick = false
    t.modules.touch = false
    t.modules.mouse = false

end
