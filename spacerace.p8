pico-8 cartridge // http://www.pico-8.com
version 27
__lua__

local spaceship
local score
local board_top
local board_right
local board_left
local spaceship_starting_y
local asteroids

function _init() 
    board_top=0
    board_right=128
    board_left=0
    spaceship_starting_y=110
    spaceship=make_spaceship()
    asteroids={}

    for i=1,25 do
        local direction = i % 2 == 0 and 1 or -1
        add(asteroids, make_asteroid(rnd(120),rnd(90),direction))
    end
end

function _update()
    spaceship:update()
    local asteroid
    for asteroid in all(asteroids) do
        asteroid:update()
        spaceship:check_for_collision(asteroid)
    end
end

function _draw() 
    cls()   
    spaceship:draw()
    for asteroid in all(asteroids) do
        asteroid:draw()
    end
end

function make_spaceship()
    return {
        x=64,
        y=spaceship_starting_y,
        speed=2,
        score=0,
        width=8,
        radius=4,
        update=function(self)
            if btn(3) and self.y<spaceship_starting_y then
                self.y+=self.speed
            end
            if btn(2) then
                self.y-=self.speed
            end

            if self.y == board_top then
                self.score+=1
                self.y=spaceship_starting_y
            end
        end,
        draw=function(self)
            spr(1,self.x-3,self.y-4)
            print(self.score, self.x-2*self.width,spaceship_starting_y,7)
        end,
        check_for_collision=function(self,asteroid)
            if circles_overlapping(self.x,self.y,self.radius,asteroid.x,asteroid.y,asteroid.radius) then 
                self.y=spaceship_starting_y
                sfx(0)
            end
        end
    }
end

function make_asteroid(starting_x,starting_y,right_or_left)
    return {
        x=starting_x,
        y=starting_y,
        radius=1.5,
        direction=right_or_left,
        update=function(self)
            self.x+=self.direction
            if self.x > board_right then
                self.x=board_left
            end
            if self.x < board_left then
                self.x=board_right
            end
        end,
        draw=function(self)
            circfill(self.x,self.y,self.radius,7)
        end
    }
end

function circles_overlapping(x1,y1,r1,x2,y2,r2)
    local dx=x2-x1
    local dy=y2-y1
    local distance=sqrt(dx*dx+dy*dy)
    return distance < (r1+r2)
end

__gfx__
00000000000770000aaaaa0000000000444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000776700aafffaa0044444444fffff400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070007776770af3f3fa000fffff44f5f5f400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000776700afffffaa00f4f4f04fffff400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000776700aff8ff0a00fffff04ff8ff400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070007776770a0fff00000ff8ff0407a70400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777770eeeee00011151114faaaf400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000980098000eee00000011100407a70040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000000000000000000000000000002f0502e0502d0502c0502a05024050230501e0001e000200001d00000000000000000000000000000000000000000000000000000000000000000000000000000000000
