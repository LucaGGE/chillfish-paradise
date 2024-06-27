-- screen pixel-perfect adjustment (screen size must always be even)
function pixel_adjust(w, h)
    if w % 2 ~= 0 then
        w = w + 1
    end
    if h % 2 ~= 0 then
        h = h + 1
    end
    print(("Window resized to width: %d and height: %d."):format(w, h))
    return w, h
end

-- screen resizing handling
function love.resize(w, h)
    window_width, window_height = pixel_adjust(w, h)
end