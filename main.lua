local level = require("level")
local whitePlayer = require("player_black")
local blackPlayer = require("player")

local sfxEnabled = true
local settingMenuActive = false

local BUTTON_H = 64
local FontSize = love.graphics.newFont(34)
local FontLarge = love.graphics.newFont(48)

levelIndex = 0

local sounds = {
    click = love.audio.newSource("assets/sounds/click.wav", "static")
}

local function newbutton(getTextFn, fn)
    return {
        getText = getTextFn,
        fn = fn
    }
end

local menuButtons = {}
local settingsButtons = {}

function love.load()
    table.insert(menuButtons, newbutton(function() return "Start Game" end, function()
        if levelIndex == 0 then
            levelIndex = 1
            level.load("levels/1.json")

            if sfxEnabled then love.audio.play(sounds.click) end

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

                if sfxEnabled then love.audio.play(sounds.click) end

                whitePlayer.load(wx, wy)
                blackPlayer.load(bx, by)
            end
        end
    end))
    
    
    table.insert(menuButtons, newbutton(
        function() return "Settings" end,
        function()
            if sfxEnabled then love.audio.play(sounds.click) end
            settingMenuActive = true
        end
    ))

    table.insert(menuButtons, newbutton(function() return "Exit" end, function()
        if sfxEnabled then love.audio.play(sounds.click) end
        
        love.event.quit(0)
    end))

    tileSize = 32
    level.load("levels/0.json")

    if levelIndex ~= 0 and levelIndex ~= "1to2" and levelIndex ~= "2to3" then
        local wx, wy = level.getPlayerStart(8)
        local bx, by = level.getPlayerStart(9)
        whitePlayer.load(wx, wy)
        blackPlayer.load(bx, by)
    end
end

table.insert(settingsButtons, newbutton(
    function() return sfxEnabled and "SFX: ON" or "SFX: OFF" end,
    function()
        sfxEnabled = not sfxEnabled
        if sfxEnabled then love.audio.play(sounds.click) end
    end
))

table.insert(settingsButtons, newbutton(
    function() return "Back to Menu" end,
    function()
        settingMenuActive = false
        if sfxEnabled then love.audio.play(sounds.click) end
        levelIndex = 0
        level.load("levels/0.json")
    end
))

function love.update(dt)
    if levelIndex == "1to2" or levelIndex == "2to3" then
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

    -- Back to menu if win or lose
    if levelIndex == "win" or levelIndex == "lose" then
        if love.keyboard.isDown("return") then
            levelIndex = 0
            level.load("levels/0.json")
        end
        return
    end

    whitePlayer.update(dt)
    blackPlayer.update(dt)

    local whiteTile = level.map[whitePlayer.y] and level.map[whitePlayer.y][whitePlayer.x]
    local blackTile = level.map[blackPlayer.y] and level.map[blackPlayer.y][blackPlayer.x]
    local spikeTiles = { [4] = true, [5] = true, [6] = true, [7] = true }

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
    local BASE_WIDTH = 800
    local BASE_HEIGHT = 600
    local scaleX = love.graphics.getWidth() / BASE_WIDTH
    local scaleY = love.graphics.getHeight() / BASE_HEIGHT
    local scale = math.min(scaleX, scaleY)

    love.graphics.push()
    love.graphics.scale(scale)

    -- SETTINGS MENU
    if settingMenuActive then
        love.graphics.setFont(FontLarge)
        love.graphics.printf("Settings", 0, 80, BASE_WIDTH, "center")

        love.graphics.setFont(FontSize)
        for i, button in ipairs(settingsButtons) do
            local x = BASE_WIDTH / 2 - 100
            local y = 200 + (i - 1) * (BUTTON_H + 10)
            love.graphics.setColor(0.2, 0.2, 0.8)
            love.graphics.rectangle("fill", x, y, 200, BUTTON_H, 12)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(button.getText(), x, y + 15, 200, "center")
        end

        love.graphics.pop()
        return
    end

    -- MAIN MENU
    if levelIndex == 0 then
        level.draw()
        level.drawTopLayer()

        love.graphics.setFont(FontLarge)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("ShadowSwap", 0, 80, BASE_WIDTH, "center")

        love.graphics.setFont(FontSize)
        for i, button in ipairs(menuButtons) do
            local x = BASE_WIDTH / 2 - 100
            local y = 200 + (i - 1) * (BUTTON_H + 10)
            love.graphics.setColor(0.2, 0.2, 0.8)
            love.graphics.rectangle("fill", x, y, 200, BUTTON_H, 12)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(button.getText(), x, y + 15, 200, "center")
        end

        love.graphics.pop()
        return
    end

    -- TRANSITION
    if levelIndex == "1to2" or levelIndex == "2to3" then
        level.draw()
        level.drawTopLayer()
        love.graphics.setFont(FontSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press Enter to Continue...", 0, BASE_HEIGHT / 2, BASE_WIDTH, "center")
        love.graphics.pop()
        return
    end

    -- GAMEPLAY
    if levelIndex ~= "win" and levelIndex ~= "lose" then
        level.draw()
        whitePlayer.draw()
        blackPlayer.draw()
        level.drawTopLayer()
    else
        -- WIN or LOSE
        level.draw()
        level.drawTopLayer()
        love.graphics.setFont(FontLarge)

        if levelIndex == "win" then
            love.graphics.setColor(0, 1, 0)
            love.graphics.printf("YOU WIN!", 0, BASE_HEIGHT / 2 - 40, BASE_WIDTH, "center")
        elseif levelIndex == "lose" then
            love.graphics.setColor(1, 0, 0)
            love.graphics.printf("YOU DIED!", 0, BASE_HEIGHT / 2 - 40, BASE_WIDTH, "center")
        end

        love.graphics.setFont(FontSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press Enter to return to menu", 0, BASE_HEIGHT / 2 + 20, BASE_WIDTH, "center")
    end

    love.graphics.pop()
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local activeButtons = settingMenuActive and settingsButtons or menuButtons
        for i, btn in ipairs(activeButtons) do
            local bx = love.graphics.getWidth() / 2 - 100
            local by = 200 + (i - 1) * (BUTTON_H + 10)
            if x >= bx and x <= bx + 200 and y >= by and y <= by + BUTTON_H then
                btn.fn()
            end
        end
    end
end

