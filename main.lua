function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    hero = love.graphics.newImage("img/heros.png")
end

function love.update(dt)
end

function love.draw()
    love.graphics.draw(hero, 0, 0)
end
