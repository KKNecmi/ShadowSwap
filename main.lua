local level = require("level")
local whitePlayer = require("player_black")
local blackPlayer = require("player")
local BUTTON_H = 64
FontSize = love.graphics.newFont(34) -- 32 is the font size

levelIndex = 0

local function newbutton(text, fn)
    return {
        text = text,
        fn = fn
    }
end

local buttons = {}

function love.load()
    table.insert(buttons, newbutton(
        "Start Game",
        function()
            if levelIndex == 0 then
                levelIndex = 1
                level.load("levels/1.json")
                
                local wx, wy = level.getPlayerStart(8)
                local bx, by = level.getPlayerStart(9)

                whitePlayer.load(wx, wy)
                blackPlayer.load(bx, by)
            elseif type(levelIndex) == "number" then
                levelIndex = levelIndex + 1
                local success, err = pcall(function()
                    level.load("levels/" .. levelIndex .. ".json")
                end)
                if success then
                    local wx, wy = level.getPlayerStart(8)
                    local bx, by = level.getPlayerStart(9)

                    whitePlayer.load(wx, wy)
                    blackPlayer.load(bx, by)
                end
            end
        end))
    table.insert(buttons, newbutton(
        "Exit",
        function()
            love.event.quit(0)
        end))
    -- Global değişkenler tanımlanıyor
    tileSize = 32

    -- Level yükleniyor
    level.load("levels/0.json")

    if levelIndex == 0 or levelIndex == "1to2" or levelIndex == "2to3" then
        
    else
        local wx, wy = level.getPlayerStart(8)
        local bx, by = level.getPlayerStart(9)

        whitePlayer.load(wx, wy)
        blackPlayer.load(bx, by)
    end
end

function love.update(dt)
    if levelIndex == "1to2" then
        -- Wait for key press to continue
        if love.keyboard.isDown("return") then
            levelIndex = 2
            level.load("levels/2.json")
            local wx, wy = level.getPlayerStart(8)
            local bx, by = level.getPlayerStart(9)
            whitePlayer.load(wx, wy)
            blackPlayer.load(bx, by)
        end
        return
    end

    whitePlayer.update(dt)
    blackPlayer.update(dt)

    -- Kazanma veya kaybetme kontrolü (tek oyuncu bile yeterli)
    local whiteTile = level.map[whitePlayer.y] and level.map[whitePlayer.y][whitePlayer.x]
    local blackTile = level.map[blackPlayer.y] and level.map[blackPlayer.y][blackPlayer.x]

    local spikeTiles = { [4] = true, [5] = true, [6] = true, [7] = true }

    -- Kaybetme
    if spikeTiles[whiteTile] or spikeTiles[blackTile] then
        levelIndex = "lose"
        level.load("levels/lose.json")
        return
    end

    if whitePlayer.onGoal and blackPlayer.onGoal then
        if levelIndex == 1 then
            levelIndex = "1to2"
            level.load("levels/1to2.json")
        elseif type(levelIndex) == "number" then
            levelIndex = levelIndex + 1
            local success, err = pcall(function()
                level.load("levels/" .. levelIndex .. ".json")
            end)
            if success then
                local wx, wy = level.getPlayerStart(5)
                local bx, by = level.getPlayerStart(6)
                whitePlayer.load(wx, wy)
                blackPlayer.load(bx, by)
            else
                levelIndex = "win"
                level.load("levels/win.json")
                return
            end
        end
    end
end

function love.draw()
    -- Ana menü
    if levelIndex == 0 then
        level.draw()
        level.drawTopLayer()

        love.graphics.setFont(FontSize)
        for i, button in ipairs(buttons) do
            local x = love.graphics.getWidth() / 2 - 100
            local y = 200 + (i - 1) * (BUTTON_H + 10)
            love.graphics.setColor(0.2, 0.2, 0.8)
            love.graphics.rectangle("fill", x, y, 200, BUTTON_H, 12)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(button.text, x, y + 15, 200, "center")
        end
        return
    end

    -- Geçiş sahnesi (karakterler çizilmez!)
    if levelIndex == "1to2" or levelIndex == "2to3" then
        level.draw()
        level.drawTopLayer()
        love.graphics.setFont(FontSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press Enter to Continue...", 0, love.graphics.getHeight() / 2 - 16, love.graphics.getWidth(), "center")
        return
    end

    -- Normal oyun sahnesi
    if levelIndex ~= "win" and levelIndex ~= "lose" then
        level.draw()
        whitePlayer.draw()
        blackPlayer.draw()
        level.drawTopLayer()
    else
        -- win veya lose sahnesi: sadece arka plan + mesaj
        level.draw()
        level.drawTopLayer()

        -- Kazanma veya kaybetme mesajı
        if levelIndex == "win" then
            love.graphics.setFont(FontSize)
            love.graphics.setColor(0, 1, 0)
            love.graphics.printf("YOU WIN!", 0, love.graphics.getHeight() / 2 - 40, love.graphics.getWidth(), "center")
        elseif levelIndex == "lose" then
            love.graphics.setFont(FontSize)
            love.graphics.setColor(1, 0, 0)
            love.graphics.printf("YOU DIED!", 0, love.graphics.getHeight() / 2 - 40, love.graphics.getWidth(), "center")
        end
    end
end

function love.mousepressed(x, y, button)
    if levelIndex == 0 and button == 1 then -- Sol tık ve ana menüdeysek
        for i, btn in ipairs(buttons) do
            local bx = love.graphics.getWidth() / 2 - 100
            local by = 200 + (i - 1) * (BUTTON_H + 10)
            if x >= bx and x <= bx + 200 and y >= by and y <= by + BUTTON_H then
                btn.fn() -- Buton fonksiyonunu çalıştır
            end
        end
    end
end
