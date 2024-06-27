-- Chillfish Paradise by Luca Giovani, 2024.

-- requiring dependencies
require "src.dependencies"

-- initializing main variables
local GAME_SCREEN
GAME_TITLE = 'Chillfish Paradise'
love.window.setTitle(GAME_TITLE)
love.graphics.setDefaultFilter("nearest", "nearest")
window_width = 640 -- screen size must be == odd number to have perfect pixels
window_height = 720
SIZE_MULTIPLIER = 1 -- 'zooms' the image in or out. Default 1, can be changed for pixel reasons
canvas = love.graphics.newCanvas(640, 720)

-- game images
IMG = {
    ['skybox'] = love.graphics.newImage('graphics/skybox.png')
}

skybox_width = IMG['skybox']:getWidth()
skybox_corner = skybox_width - window_width

-- variable for storing and clearing keys pressed each update
keys_pressed = {}
camera_position = 0
camera_movement = 1

function love.keypressed(key)
    -- all inputs with few system-related exceptions are handled inside Game States    
    if key == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen)
        --g.window_width, g.window_height = pixel_adjust(love.graphics.getDimensions())
    else
        --g.game_state:manage_input(key)
    end
end

function love.load()
    -- game screen and tile settings
    GAME_SCREEN = love.window.setMode(
    window_width, window_height, {resizable=true, vsync=0, minwidth=400, minheight=300}
    )

    --g.game_state:init()
end

function love.update(dt)
    --Timer.update(dt)
    --g.game_state:update()
    
    -- Scrolling text <--- WORKING!!!
    camera_position = camera_position + 0.2

    -- Camera movement by texture translation
    if love.mouse.isDown(1) then
		camera_position = camera_position + camera_movement
    elseif love.mouse.isDown(2) then
        camera_position = camera_position - camera_movement
	end

    -- Checking if texture is wrapping correctly
    if camera_position > 0 then
        camera_position = camera_position - skybox_corner -- note: this hardcoded value is the texture's right angle - a block's (screen) width
    elseif camera_position < -skybox_corner then
        camera_position = camera_position + skybox_corner
    end
end

function love.draw()
    love.graphics.setCanvas(canvas)
    
    -- setting canvas to final and drawing on it
    love.graphics.clear(0.5, 0.5, 0.5)
    love.graphics.draw(IMG['skybox'], camera_position, 0)
    
    -- drawing in a loop all the elements to be drawn on screen, removing dead ones
    --for i, img in ipairs(render_group) do
    --    love.graphics.draw(g.TILESET, tile_to_quad(entity.tile), entity.cell["cell"].x, entity.cell["cell"].y)
    --end

    -- Reset default canvas and draw g.canvas_final on the screen, with g.camera offset.
    love.graphics.setCanvas()

    -- screen is drawn on canvas_final
    love.graphics.draw(canvas, 0, 0, 0, SIZE_MULTIPLIER, SIZE_MULTIPLIER)

    -- drawing UI on top of everything + setting its color   
    --love.graphics.setFont(FONTS["subtitle"])
    --love.graphics.setColor(0.78, 0.96, 0.94, 1)
    --love.graphics.print("Test", 0, 0, 0)

    -- restoring default RGBA, since this function influences ALL graphics
    --love.graphics.setColor(1, 1, 1, 1)
end