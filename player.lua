local level = require("level")
local player_white = love.graphics.newImage("assets/images/player_white.png")

local player = {}

player.x = 0
player.y = 0
player.speed = 1
player.pixelX = 0
player.pixelY = 0
player.moveTimer = 0
player.moveCooldown = 0.2
player.onGoal = false

function player.load(startX, startY)
    player.x = startX
    player.y = startY
    player.pixelX = (startX - 1) * tileSize
    player.pixelY = (startY - 1) * tileSize
end

function player.update(dt)
    player.moveTimer = player.moveTimer - dt

    if player.moveTimer <= 0 then
        local moveX, moveY = 0, 0

        if love.keyboard.isDown("up") then moveY = -1 end
        if love.keyboard.isDown("down") then moveY = 1 end
        if love.keyboard.isDown("left") then moveX = -1 end
        if love.keyboard.isDown("right") then moveX = 1 end

        if moveX ~= 0 or moveY ~= 0 then
            local newX = player.x + moveX
            local newY = player.y + moveY

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
                player.x = newX
                player.y = newY
                player.pixelX = (newX - 1) * tileSize
                player.pixelY = (newY - 1) * tileSize

                -- Hareket edildiyse tekrar bekleme başlat
                player.moveTimer = player.moveCooldown
            end
        end
    end
    local currentTile = level.map[player.y] and level.map[player.y][player.x]
    player.onGoal = currentTile == 3
end

function player.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(player_white, player.pixelX, player.pixelY)
end

return player
