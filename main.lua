-- Prevent love to filter images on resized
love.graphics.setDefaultFilter("nearest")

heros = {}
sprites = {}

heros.x = 0
heros.y = 0

function createSprite(pImgName, pX, pY)
    sprite = {}
    sprite.x = pX
    sprite.y = pY
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
    if love.keyboard.isDown("up") then
        heros.y = heros.y - 1
    end
    if love.keyboard.isDown("right") then
        heros.x = heros.x + 1
    end

    if love.keyboard.isDown("down") then
        heros.y = heros.y + 1
    end
    if love.keyboard.isDown("left") then
        heros.x = heros.x - 1
    end
end

function love.draw()
    local n
    for n = 1, #sprites do
        local s = sprites[n]
        love.graphics.draw(s.img, s.x, s.y, 0, 2, 2, s.width / 2, s.height / 2)
    end
end

function love.keypressed(key)
end
