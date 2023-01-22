-- Prevent love to filter images on resized
love.graphics.setDefaultFilter("nearest")

heros = {}
sprites = {}
shoots = {}

heros.x = 0
heros.y = 0

soundShoot = love.audio.newSource("sound/shoot.wav", "static")

function createSprite(pImgName, pX, pY)
    sprite = {}
    sprite.x = pX
    sprite.y = pY
    sprite.delete = false
    sprite.img = love.graphics.newImage("img/" .. pImgName .. ".png")
    sprite.width = sprite.img:getWidth()
    sprite.height = sprite.img:getHeight()

    table.insert(sprites, sprite)

    return sprite
end

function love.load()
    love.window.setMode(1024, 768)
    love.window.setTitle("Shmup")

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    heros = createSprite("heros", width / 2, height / 2)
    heros.y = height - (heros.height * 2)
end

function love.update(dt)
    local n
    for n = #shoots, 1, -1 do
        local shoot = shoots[n]
        shoot.y = shoot.y + shoot.speed

        -- check if the shoot is in the screen
        if shoot.y < 0 or shoot.y > height then
            shoot.delete = true
            table.remove(shoots, n)
        end
    end

    for n = #sprites, 1, -1 do
        if sprites[n].delete == true then
            table.remove(sprites, n)
        end
    end

    if love.keyboard.isDown("up") and heros.y > 0 then
        heros.y = heros.y - 1
    end
    if love.keyboard.isDown("right") and heros.x < width then
        heros.x = heros.x + 1
    end

    if love.keyboard.isDown("down") and heros.y < height then
        heros.y = heros.y + 1
    end
    if love.keyboard.isDown("left") and heros.x > 0 then
        heros.x = heros.x - 1
    end
end

function love.draw()
    local n
    for n = 1, #sprites do
        local s = sprites[n]
        love.graphics.draw(s.img, s.x, s.y, 0, 2, 2, s.width / 2, s.height / 2)
    end

    love.graphics.print("shoot " .. #shoots, 0, 0)
end

function love.keypressed(key)
    if key == "space" then
        local shoot = createSprite("laser1", heros.x, heros.y - (heros.height * 2) / 2)
        shoot.speed = -10
        table.insert(shoots, shoot)

        soundShoot:play()
    end
end
