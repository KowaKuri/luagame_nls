-- files needed for proper functioning --
local class = require("class")
local Sprite = class:derive("Player")
local Anim = require("Animation")
local Vector2 = require("Vector2")

function Player:new(hero, x, y, w, h, px, py, angle, sx, sy) -- this function creates a new hero (character)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.pos = Vector2(px or 0, py or 0) -- screen position
	self.angle = angle or 0
	self.scale = Vector2(sx or 1, sy or 1) -- put it to 1
	self.flip = Vector2(1,1)
	self.hero = hero
	self.animations = {}
	self.current_anim = "idle" -- this bit is setting the starting animation of the sprite (it should be set to idle)
	self.quad = love.graphics.newQuad(x,y,w,h,hero:getDimensions()) -- aaand this bit creates our hero_sprite (former)
end

function Player:animate(anim_name)
	if self.current_anim ~= anim_name and self.animations[anim_name] ~= nil then
		self.animations[anim_name]:reset()
		self.animations[anim_name]:set(self.quad)
		self.current_anim = anim_name
	end
end

function Player:flip_h(flip)
	if flip then
		self.flip.x = -1
	else
		self.flip.x = 1
	end
end

function Player:flip_v(flip)
	if flip then
		self.flip.y = -1
	else
		self.flip.y = 1
	end
end

function Player:animation_finished()
	if self.animations[self.current_anim] ~= nil then
		return self.animations[self.current_anim].done
	end
	return false
end

function Player:add_animation(name, anim) -- new animation type
	self.animations[name] = anim
end

function Player:update(dt)
	if self.animations[self.current_anim] ~= nil then
		self.animations[self.current_anim]:update(dt,self.quad) -- this bit calling update function in Animation class
	end
end

function Player:draw()
	love.graphics.draw(self.hero,self.quad,self.pos.x,self.pos.y,math.rad(self.angle),self.scale.x * self.flip.x,self.scale.y * self.flip.y,self.w/2,self.h/2) -- yay! we are drawing the hero
end


return Player