-- Prevent love to filter images on resized
love.graphics.setDefaultFilter("nearest")

heros = {}

math.randomseed(love.timer.getTime())

-- List
listSprites = {}
listShoots = {}
listAliens = {}

-- Level 16x12
level = {}
table.insert(level, {0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
table.insert(level, {0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
table.insert(level, {0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
table.insert(level, {0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
table.insert(level, {0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
table.insert(level, {0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
table.insert(level, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
table.insert(level, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
table.insert(level, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 0, 0, 0})
table.insert(level, {0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 3, 3, 3, 0, 0, 0})
table.insert(level, {0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 3, 3, 3, 0, 0, 0})
table.insert(level, {0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 3, 3, 3, 0, 0, 0})

-- Camera

camera = {
    y = 0
}

-- Tiles Img
tilesImg = {}

local n
for n = 1, 3 do
    tilesImg[n] = love.graphics.newImage("img/tuile_" .. n .. ".png")
end

soundShoot = love.audio.newSource("sound/shoot.wav", "static")

function createAlien(pType, pX, pY)
    local imgName = ""
    if pType == "1" then
        imgName = "enemy1"
    elseif pType == "2" then
        imgName = "enemy2"
    end

    local alien = createSprite(imgName, pX, pY)

    if pType == "1" then
        alien.vY = 2
        alien.vX = 0
    elseif pType == "2" then
        alien.vY = 2
        local direction = math.random(1, 2)
        if direction == 1 then
            alien.vX = 1
        else
            alien.vX = -1
        end
    end

    table.insert(listAliens, alien)
end

function createSprite(pImgName, pX, pY)
    sprite = {}
    sprite.x = pX
    sprite.y = pY
    sprite.delete = false
    sprite.img = love.graphics.newImage("img/" .. pImgName .. ".png")
    sprite.width = sprite.img:getWidth()
    sprite.height = sprite.img:getHeight()

    table.insert(listSprites, sprite)

    return sprite
end

function love.load()
    love.window.setMode(1024, 768)
    love.window.setTitle("Shmup")

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    heros = createSprite("heros", width / 2, height / 2)

    startGame()
end

function startGame()
    heros.x = width / 2
    heros.y = height - (heros.height * 2)
    createAlien("1", width / 2, 100)
    createAlien("2", width / 2, 50)

    -- reset camera
    camera.y = 0
end

function love.update(dt)
    -- Move camera
    camera.y = camera.y + 1

    local n
    for n = #listShoots, 1, -1 do
        local shoot = listShoots[n]
        shoot.y = shoot.y + shoot.speed

        -- check if the shoot is in the screen
        if shoot.y < 0 or shoot.y > height then
            shoot.delete = true
            table.remove(listShoots, n)
        end
    end

    -- Aliens
    for n = #listAliens, 1, -1 do
        local alien = listAliens[n]
        alien.x = alien.x + alien.vX
        alien.y = alien.y + alien.vY

        if alien.y > height then
            alien.delete = true
            table.remove(listAliens, n)
        end
    end
    ---------------------------------
    for n = #listSprites, 1, -1 do
        if listSprites[n].delete == true then
            table.remove(listSprites, n)
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
    -- Draw the level
    local nbLine = #level
    local line, column
    local x, y

    x = 0
    y = (0 - 64) + camera.y

    for line = nbLine, 1, -1 do
        for column = 1, 16 do
            -- Draw the tile
            local tile = level[line][column]
            if level[line][column] > 0 then
                love.graphics.draw(tilesImg[tile], x, y, 0, 2, 2)
            end

            x = x + 64
        end
        x = 0
        y = y - 64
    end

    -------------------------------
    local n
    for n = 1, #listSprites do
        local s = listSprites[n]
        love.graphics.draw(s.img, s.x, s.y, 0, 2, 2, s.width / 2, s.height / 2)
    end

    love.graphics.print("shoot = " .. #listShoots .. " Sprites = " .. #listSprites .. "Aliens = " .. #listAliens, 0, 0)
end

function love.keypressed(key)
    if key == "space" then
        local shoot = createSprite("laser1", heros.x, heros.y - (heros.height * 2) / 2)
        shoot.speed = -10
        table.insert(listShoots, shoot)

        soundShoot:play()
    end
end
