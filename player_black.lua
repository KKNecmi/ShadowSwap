local level = require("level")
local player_shadow = love.graphics.newImage("assets/images/player_shadow.png")

local black = {}

black.x = 0
black.y = 0
black.speed = 1
black.pixelX = 0
black.pixelY = 0
black.moveTimer = 0
black.moveCooldown = 0.2
black.onGoal = false

function black.load(startX, startY)
    black.x = startX
    black.y = startY
    black.pixelX = (startX - 1) * tileSize
    black.pixelY = (startY - 1) * tileSize
end

function black.update(dt)
    black.moveTimer = black.moveTimer - dt

    if black.moveTimer <= 0 then
        local moveX, moveY = 0, 0

        -- CONTROLS ARE REVERSED
        if love.keyboard.isDown("up") then moveY = 1 end -- REVERSED
        if love.keyboard.isDown("down") then moveY = -1 end -- REVERSED
        if love.keyboard.isDown("left") then moveX = 1 end  -- REVERSED
        if love.keyboard.isDown("right") then moveX = -1 end -- REVERSED

        if moveX ~= 0 or moveY ~= 0 then
            local newX = black.x + moveX
            local newY = black.y + moveY

            local walkable = {
                [3] = true, -- Goal
                [4] = true, -- Spike
                [5] = true, -- SpikeLeft
                [6] = true, -- SpikeRight
                [7] = true, -- SpikeReversed
                [8] = true, -- White Player Start
                [9] = true,   -- Black Player Start
                [10] = true  -- Air
            }

            local targetTile = level.map[newY] and level.map[newY][newX]
            if walkable[targetTile] then
                black.x = newX
                black.y = newY
                black.pixelX = (newX - 1) * tileSize
                black.pixelY = (newY - 1) * tileSize
                black.moveTimer = black.moveCooldown
            end
        end
    end
    local currentTile = level.map[black.y] and level.map[black.y][black.x]
    black.onGoal = currentTile == 3
end

function black.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(player_shadow, black.pixelX, black.pixelY)
end

return black
