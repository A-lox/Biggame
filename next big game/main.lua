function love.load()
    spawntime = 0
    yesspawn = love.math.random(1,5)
    wf = require "libreries/windfield"
    world = wf.newWorld(0,0)
    world:setGravity(0,0)
    local wheight = love.graphics.getHeight( )
    local wwidth = love.graphics.getWidth( )
    player = {}
    player.pose = {}
    player.pose.w = 50
    player.pose.h = 50
    player.pose.x = wwidth/ 2 - player.pose.w /2
    player.pose.y = wheight/ 2 - player.pose.h /2 - 100
    player.pose.velocity = 230
    player.pose.maxvelocity = 150
    player.hitbox = world:newRectangleCollider(player.pose.x, player.pose.y, player.pose.w, player.pose.h)
    player.hitbox:setFixedRotation(true)
    player.sprite = {}
    enemys = {}
    new_enemy(3,"true")
end

function love.draw() 
    world:draw()
end

function love.update(dt)
playerkeys()
world:update(dt)
enemy_update(dt)

spawntime = spawntime + 1*dt
if spawntime >= yesspawn then
    local random = love.math.random(1,3)
    new_enemy(random,"true")
    yesspawn = love.math.random(1,5)
    spawntime = 0
end
end

function playerkeys()
    local vx = 0
    local vy = 0
    local px, py = player.hitbox:getLinearVelocity()
    if love.keyboard.isDown("w") then
        vy = player.pose.velocity * -1
        player.pose.y = player.pose.y - player.pose.velocity
    end
    if love.keyboard.isDown("a") then
        vx = player.pose.velocity * -1
        player.pose.x = player.pose.x - player.pose.velocity
    end
    if love.keyboard.isDown("s") then
        vy = player.pose.velocity
        player.pose.y = player.pose.y + player.pose.velocity
    end
    if love.keyboard.isDown("d") then
        vx = player.pose.velocity
        player.pose.x = player.pose.x + player.pose.velocity
    end

    player.hitbox:setLinearVelocity(vx,vy)
end

function new_enemy(a,i)
    for i=1,a do 
        enemy = {}
        enemy.x = love.math.random(0,400)
        enemy.y = love.math.random(0, 668)
        enemy.mx = 0
        enemy.my = 0
        enemy.rot = love.math.random(1,4)
        enemy.w = 30
        enemy.h = 30
        enemy.t = 0
        enemy.speedmy = love.math.random(150,200)
        enemy.speedpy = love.math.random(-150,-200)
        enemy.ran = love.math.random(0.9,1)
        enemy.hitbox = world:newRectangleCollider(enemy.x,enemy.y,enemy.w,enemy.h)
        table.insert(enemys,enemy)
    end
end

function enemy_update(dt)
   
    for i,c in ipairs(enemys) do
        c.t = c.t + 1*dt

            if c.rot == 1 then
                
            if c.t >= 0.6 then
                c.my = c.speedmy
            end

            if c.t >= c.ran then
                c.my = 0
                c.t = 0
            end
          

    
        elseif c.rot == 2 then
            if c.t >= 0.6 then
                c.my = c.speedpy
            end

            if c.t >= c.ran then
                c.my = 0
                c.t = 0
            end
        elseif c.rot == 3 then
        elseif c.rot == 4 then
        end
    c.hitbox:setLinearVelocity(0,c.my*-1)
    end
end

function love.keypressed(key)
    if key=="space" then 
        new_enemy(1)
    end
end