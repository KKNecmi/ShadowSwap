local tileSize = 32

local level = {}

-- JSON verisini okuyabilmek için decode fonksiyonu (Love2D 11.x+)
local json = require("dkjson")  -- veya "json" modülü kullanıyorsan onu çağır

tileset = love.graphics.newImage("assets/images/tileset.png")

-- 2. Tile'lara ait quads (alt görüntüler) oluştur
tileQuads = {
    [0] = love.graphics.newQuad(0, 0, tileSize, tileSize, tileset:getDimensions()), -- Grass
    [1] = love.graphics.newQuad(0, 32, tileSize, tileSize, tileset:getDimensions()), -- Dirt
    [2] = love.graphics.newQuad(32, 0, tileSize, tileSize, tileset:getDimensions()), -- Wall
    [3] = love.graphics.newQuad(64, 0, tileSize, tileSize, tileset:getDimensions()), -- Goal
    [4] = love.graphics.newQuad(96, 0, tileSize, tileSize, tileset:getDimensions()), -- Spike
    [5] = love.graphics.newQuad(96, 32, tileSize, tileSize, tileset:getDimensions()), -- SpikeLeft
    [6] = love.graphics.newQuad(96, 64, tileSize, tileSize, tileset:getDimensions()), -- SpikeRight
    [7] = love.graphics.newQuad(96, 96, tileSize, tileSize, tileset:getDimensions()), -- SpikeReversed
    [8] = love.graphics.newQuad(128, 0, tileSize, tileSize, tileset:getDimensions()), -- White Player Start
    [9] = love.graphics.newQuad(128, 32, tileSize, tileSize, tileset:getDimensions()), -- Black Player Start
    [10] = love.graphics.newQuad(160, 0, tileSize, tileSize, tileset:getDimensions())  -- Air
}

function level.load(path)
    local file = love.filesystem.read(path)
    local data, _, err = json.decode(file)

    if err then
        error("JSON decode hatası: " .. err)
    end

    level.map = data
end

function level.draw()
    for y = 1, #level.map do
        for x = 1, #level.map[y] do
            local id = level.map[y][x]
            if id ~= 3 and id ~= 4 and id ~= 5 and id ~= 6 and id ~= 7 then
                local quad = tileQuads[id]
                if quad then
                    love.graphics.draw(tileset, quad, (x - 1) * tileSize, (y - 1) * tileSize)
                end
            end
        end
    end
end

function level.drawTopLayer()
    for y = 1, #level.map do
        for x = 1, #level.map[y] do
            local id = level.map[y][x]

            -- Oyuncunun üstünde durması gerekenler
            if id == 3 or id == 4 or id == 5 or id == 6 or id == 7 or id == 8 or id == 9 then -- Goal ve PlayerStart üstte
                local quad = tileQuads[id]
                if quad then
                    love.graphics.draw(tileset, quad, (x - 1) * tileSize, (y - 1) * tileSize)
                end
            end
        end
    end
end

function level.getPlayerStart(tileId)
    for y = 1, #level.map do
        for x = 1, #level.map[y] do
            if level.map[y][x] == tileId then
                return x, y
            end
        end
    end
    return nil, nil
end


return level
