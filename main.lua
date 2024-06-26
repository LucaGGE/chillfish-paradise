-- Chillfish Paradise by Luca Giovani, 2024.

-- requiring dependencies
require "src.dependencies"

-- initializing main variables
local GAME_SCREEN
GAME_TITLE = 'Chillfish Paradise'
love.window.setTitle(GAME_TITLE)
love.graphics.setDefaultFilter("nearest", "nearest")

-- current state of the game

-- variable for storing and clearing keys pressed each update
keys_pressed = {}

function love.keypressed(key)
    -- all inputs with few system-related exceptions are handled inside Game States    
    if key == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen)
        g.window_width, g.window_height = pixel_adjust(love.graphics.getDimensions())
    else
        g.game_state:manage_input(key)
    end
end

function love.load()
    -- game screen and tile settings
    GAME_SCREEN = love.window.setMode(g.window_width, g.window_height, 
    {resizable=true, vsync=0, minwidth=400, minheight=300}
    )

    g.game_state:init()
end

function love.update(dt)
    Timer.update(dt)
    g.game_state:update()
end

function love.draw()
    g.game_state:draw()
end