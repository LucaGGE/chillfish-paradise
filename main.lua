-- Chillfish Paradise by Luca Giovani, 2024.

-- requiring dependencies
require "src.dependencies"

-- initializing main variables
local GAME_SCREEN
SIZE_MULTIPLIER = 2 -- 'zooms' the image in or out. Default 1, can be changed for pixel reasons
GAME_TITLE = 'Chillfish Paradise'
love.window.setTitle(GAME_TITLE)
love.graphics.setDefaultFilter("nearest", "nearest")
canvas_width = 320 -- screen size must be == odd number to have perfect pixels
canvas_height = 640
window_width = canvas_width * SIZE_MULTIPLIER
window_height = canvas_height * SIZE_MULTIPLIER
fullscreen = true
canvas = love.graphics.newCanvas(320, 640)

-- game images
IMG = {
    ['skybox'] = love.graphics.newImage('graphics/skybox.png'),
    ['clouds'] = love.graphics.newImage('graphics/clouds.png'),
    ['sea'] = love.graphics.newImage('graphics/sea.png')
}

last_block_topleft = IMG['skybox']:getWidth() - canvas_width

-- variable for storing and clearing keys pressed each update
keys_pressed = {}
skybox_x = 0
clouds_x = 0
camera_speed = 150

function love.keypressed(key)
    -- all inputs with few system-related exceptions are handled inside Game States    
    print("Key pressed: "..key)
    if key == "f" or key == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen)
        --g.canvas_width, g.canvas_height = pixel_adjust(love.graphics.getDimensions())
    elseif key == "x" then
        love.event.quit()
    else
        --g.game_state:manage_input(key)
    end
end

function love.load()
    -- game screen and tile settings
    GAME_SCREEN = love.window.setMode(
    canvas_width, window_height,
    {resizable=true, vsync=0, minwidth= canvas_width * SIZE_MULTIPLIER, minheight= canvas_height * SIZE_MULTIPLIER}
    )

    love.window.setFullscreen(fullscreen)

    --g.game_state:init()
end

function love.update(dt)
    --Timer.update(dt)
    --g.game_state:update()
    
    -- Scrolling text <--- WORKING!!!
    clouds_x = clouds_x + (3 * dt)

    -- Camera movement by texture translation
    if love.mouse.isDown(1) then
		skybox_x = skybox_x + (camera_speed * dt)
        clouds_x = clouds_x + (camera_speed * dt)
    elseif love.mouse.isDown(2) then
        skybox_x = skybox_x - (camera_speed * dt)
        clouds_x = clouds_x - (camera_speed * dt)
	end

    -- Checking if skybox is wrapping correctly
    if skybox_x > 0 then
        skybox_x = skybox_x - last_block_topleft -- note: this hardcoded value is the texture's right angle - a block's (screen) width
    elseif skybox_x < -last_block_topleft then
        skybox_x = skybox_x + last_block_topleft
    end

    -- Checking if clouds are wrapping correctly
    if clouds_x > 0 then
        clouds_x = clouds_x - last_block_topleft -- note: this hardcoded value is the texture's right angle - a block's (screen) width
    elseif clouds_x < -last_block_topleft then
        clouds_x = clouds_x + last_block_topleft
    end
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0.5, 0.5, 0.5)
    
    love.graphics.draw(IMG['skybox'], skybox_x, 0)
    love.graphics.draw(IMG['clouds'], clouds_x, 0)
    love.graphics.draw(IMG['sea'], 0, 0)
    
    -- drawing in a loop all the elements to be drawn on screen, removing dead ones
    --for i, img in ipairs(render_group) do
    --    love.graphics.draw(g.TILESET, tile_to_quad(entity.tile), entity.cell["cell"].x, entity.cell["cell"].y)
    --end

    -- Reset default canvas and draw g.canvas_final on the screen, with g.camera offset.
    love.graphics.setCanvas()
    love.graphics.clear(173/255, 200/255, 242/255)

    -- canvas is drawn at the center of the window
    love.graphics.draw(
    canvas, 
    (window_width / 2) - canvas_width * SIZE_MULTIPLIER / 2,
    (window_height / 2) - canvas_height * SIZE_MULTIPLIER / 2,
    0, SIZE_MULTIPLIER, SIZE_MULTIPLIER
    )

    -- drawing UI on top of everything + setting its color   
    --love.graphics.setFont(FONTS["subtitle"])
    --love.graphics.setColor(0.78, 0.96, 0.94, 1)
    --love.graphics.print("Test", 0, 0, 0)

    -- restoring default RGBA, since this function influences ALL graphics
    --love.graphics.setColor(1, 1, 1, 1)
end