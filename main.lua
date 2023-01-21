hero = {}

hero.x = 50
hero.y = 10

local width
local height

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    hero.img = love.graphics.newImage("img/heros.png")
end

function love.update(dt)
    if love.keyboard.isDown("up") then
        hero.y = hero.y - 1
    end
    if love.keyboard.isDown("right") then
        hero.x = hero.x + 1
    end

    if love.keyboard.isDown("down") then
        hero.y = hero.y + 1
    end
    if love.keyboard.isDown("left") then
        hero.x = hero.x - 1
    end
end

function love.draw()
    love.graphics.draw(hero.img, hero.x, hero.y)
end
