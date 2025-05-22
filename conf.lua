function love.conf(t)
    t.window.title = "ShadowSwap"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = false
    t.window.vsync = 1
    t.console = false

    t.identity = "ShadowSwapSave"

    t.modules.physics = false
    t.modules.joystick = false
    t.modules.touch = false
    t.modules.video = false
end
