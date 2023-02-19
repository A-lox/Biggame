function love.load()
    spawntime = 0
    yesspawn = love.math.random(0.5,1.5)
    wf = require "libreries/windfield"
    world = wf.newWorld(0,0)
    world:setGravity(0,0)
    world:addCollisionClass("player")
    world:addCollisionClass("enemy")
    local wheight = love.graphics.getHeight( )
    local wwidth = love.graphics.getWidth( )
    player = {}
    player.pose = {}
    player.pose.w = 50
    player.pose.h = 50
    player.pose.x = wwidth/ 2 - player.pose.w /2
    player.pose.y = wheight/ 2 - player.pose.h /2 - 100
    player.pose.velocity = 231
    player.pose.maxvelocity = 150
    player.pose.rot = 0
    player.hitbox = world:newRectangleCollider(player.pose.x, player.pose.y, player.pose.w, player.pose.h)
    player.hitbox:setFixedRotation(true)
    player.hitbox:setCollisionClass("player")
    player.sprite = {}
    player.sprite.main = {}
    player.sprite.main.up = love.graphics.newImage("sprites/player_up.png")
    player.sprite.main.down = love.graphics.newImage("sprites/player_down.png")
    player.sprite.main.left = love.graphics.newImage("sprites/player_left.png")
    player.sprite.main.right = love.graphics.newImage("sprites/player_right.png")
    player.uprdown = 1
    player.sprite.current = player.sprite.main.up
    player.health = 5
    enemys = {}
    new_enemy(4,"true")
    data = 1
end

function love.draw() 
    bg()
    if love.keyboard.isDown("`") then
        if love.keyboard.isDown("1") then
    world:draw()
    end
    end
    draw_player()   
    enemy_draw()     
            
    gui()                                                                                                       
end

function love.update(dt)
playerkeys()
world:update(dt)
enemy_update(dt)
spawn_enemy(dt)
enemy_del(dt)
end

function playerkeys()
    local vx = 0
    local vy = 0
    local px, py = player.hitbox:getLinearVelocity()
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        vy = player.pose.velocity * -1
        player.pose.y = player.pose.y - player.pose.velocity
        player.sprite.current = player.sprite.main.up
        player.uprdown = 1
    elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        vx = player.pose.velocity * -1
        player.pose.x = player.pose.x - player.pose.velocity
        player.sprite.current = player.sprite.main.left
        player.uprdown = 2
    elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        vy = player.pose.velocity
        player.pose.y = player.pose.y + player.pose.velocity
        player.sprite.current = player.sprite.main.down
        player.uprdown = 1
    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        vx = player.pose.velocity
        player.pose.x = player.pose.x + player.pose.velocity
        player.sprite.current = player.sprite.main.right
        player.uprdown = 2
    end

    player.hitbox:setLinearVelocity(vx,vy)
end

function new_enemy(a,i)
    for i=1,a do 
        enemy = {}
        enemy.x = love.math.random(0,400)
        enemy.y = love.math.random(0, 668)
        enemy.dx = 0
        enemy.dy = 0
        enemy.mx = 0
        enemy.my = 0
        enemy.rot = love.math.random(1,4)
        enemy.w = 30
        enemy.h = 30
        enemy.t = 0
        enemy.alive = 1
        enemy.speedmy = love.math.random(150,200)
        enemy.speedpy = love.math.random(-150,-200)
        enemy.ran = love.math.random(0.9,1)
        enemy.hitbox = world:newRectangleCollider(enemy.x,enemy.y,enemy.w,enemy.h)
        enemy.hitbox:setCollisionClass("enemy")
        enemy.hitbox:setFixedRotation(true)
        enemy.sprite = {}
        enemy.sprite.up = love.graphics.newImage("sprites/fish_up.png")
        enemy.sprite.down = love.graphics.newImage("sprites/fish_down.png")
        enemy.sprite.left = love.graphics.newImage("sprites/fish_left.png")
        enemy.sprite.right = love.graphics.newImage("sprites/fish_right.png")
        table.insert(enemys,enemy)
    end
end

function enemy_draw(dt)
    
    for i,c in ipairs(enemys) do
        if c.alive == 1 then
        c.dx = c.hitbox:getX()
        c.dy = c.hitbox:getY()
        if c.rot  == 1 then
            love.graphics.draw(c.sprite.up,c.dx - 19,c.dy - 22,0,0.4,0.4)
        elseif c.rot == 2 then
            love.graphics.draw(c.sprite.down,c.dx - 19,c.dy - 22,0,0.4,0.4)
        elseif c.rot == 3 then
            love.graphics.draw(c.sprite.left,c.dx - 19,c.dy - 22,0,0.4,0.4)
        elseif c.rot == 4 then
            love.graphics.draw(c.sprite.right,c.dx - 19,c.dy - 22,0,0.4,0.4)
        end
    end
    end

end

function enemy_del(dt)
    hitx = player.hitbox:getX()
    hity = player.hitbox:getY() 
    for i,c in ipairs(enemys) do
        if c.alive == 1 then
        local dx = c.hitbox:getX()
        local dy = c.hitbox:getY()
                if  c.hitbox:enter("player")  then
                    print("colid. enemy w player - 1 hp")
                    player.health = player.health - 1
                    c.hitbox:destroy()
                    c.alive = 0
                end
        end
    end
end

function enemy_update(dt)
   
    for i,c in ipairs(enemys) do
        if c.alive == 1 then
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
            if c.t >= 0.6 then
                c.mx = c.speedmy
            end

            if c.t >= c.ran then
                c.mx = 0
                c.t = 0
            end


        elseif c.rot == 4 then
            if c.t >= 0.6 then
                c.mx = c.speedpy
            end

            if c.t >= c.ran then
                c.mx = 0
                c.t = 0
            end
        end
        c.hitbox:setLinearVelocity(c.mx*-1,c.my*-1)
        
        
     end
    end
end




function love.keypressed(key)
    if key=="space" then 
        new_enemy(1)
    end

    if key=="p" then
        save()
    end
    if key=="o" then
        reed()
    end
    if key=="l" then
        reset()
    end
    if key=="escape" then
        
    end
end

function spawn_enemy(dt)
    spawntime = spawntime + 1*dt
if spawntime >= yesspawn then
    local random = love.math.random(1,2)
    new_enemy(random,"true")
    yesspawn = love.math.random(0.4,0.9)
    spawntime = 0
end
end

function draw_player()
    
    local sx = 0.12
    local sy = 0.12
    if player.uprdown == 1 then
    love.graphics.draw(player.sprite.current,hitx - 24,hity - 35,player.pose.rot,sx,sy)
    elseif player.uprdown == 2 then
        love.graphics.draw(player.sprite.current,hitx - 35,hity - 24,player.pose.rot,sx,sy)
    end
end

function save()
    love.filesystem.write("save.txt",player.health)
    print("saving")
end

function reed()
    file = love.filesystem.read("save.txt")
    print(file)
    player.health = file
    print()
end

function reset()
print("reseting...")
love.filesystem.write("save.txt",5)
print("reset")
end

function AABB(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x1 + w1 > x2 and
           y1 < y2 + h2 and
           y1 + h1 > y2
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
  end

  function gui()
    if love.keyboard.isDown("escape") then
        fpscounter = love.timer.getFPS( )
    love.graphics.print("fps"..":"..fpscounter,5,40)
  end
  love.graphics.print(player.health,200,10)  
  love.graphics.print('press"p"to save',5,0) 
  love.graphics.print('press"o"to load',5,15)
  end

  function bg()
    love.graphics.setColor(0.6,0.6,0.7,0.4)
    love.graphics.rectangle("fill",-5,-5,800,800)
    love.graphics.setColor(1,1,1)
  end



