local class = require("class")
local Enemy = class:derive("Enemy")
local Anim = require("Animation")
local Vector2 = require("Vector2")

function Enemy:new(foe, x, y, w, h, px, py, angle, sx, sy, at) -- this function creates a new foe (character)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.pos = Vector2(px or 0, py or 0) -- screen position
	self.angle = angle or 0
	self.scale = Vector2(sx or 1, sy or 1) -- put it to 1
	self.appearence = at
	self.flip = Vector2(1,1)
	self.foe = foe
	self.animations = {}
	self.current_anim = "walk" -- this bit is setting the starting animation of the sprite (it should be set to idle)
	self.quad = love.graphics.newQuad(x,y,w,h,foe:getDimensions()) -- aaand this bit creates our foe_sprite (former)
	self.collider = world:newRectangleCollider(self.pos.x,self.pos.y,self.w*2,self.h*4)
	self.collider:setCollisionClass("Enemy")
	self.collider:setFixedRotation(true)
	self.collider:setObject(self)
	self.dead = false
	self.hurt = false
	self.life = love.math.random(1,2)
end

function Enemy:update(dt)
	self.pos.x, self.pos.y = self.collider:getPosition()
	if self.animations[self.current_anim] ~= nil then
		self.animations[self.current_anim]:update(dt,self.quad) -- this bit calling update function in Animation class
	end
	if self.collider:enter('Bullet') then
		local collision_data = self.collider:getEnterCollisionData('Bullet')
		local bullet = collision_data.collider:getObject()
		if bullet then
			bullet:dissapear()
			if self.life > 1 then
				if self.hurt == false then
					score = score + 10
					self.hurt = true
					love.audio.play(sfx_pain)
				else
					self:die()
					love.audio.play(sfx_death)
					if level == 1 then
						score = score + 20
					elseif level == 2 then
						score = score + 30
					elseif level == 3 then
						score = score + 40
					elseif level == 4 then
						score = score + 50
					else
						score = score + 60
					end
				end
			else
				self:die()
				love.audio.play(sfx_death)
				if level == 1 then
					score = score + 20
				elseif level == 2 then
					score = score + 30
				elseif level == 3 then
					score = score + 40
				elseif level == 4 then
					score = score + 50
				else
					score = score + 60
				end
			end
		end
	end
end

function Enemy:draw()
	love.graphics.draw(self.foe,self.quad,self.pos.x-18,self.pos.y-15,math.rad(self.angle),self.scale.x * self.flip.x,self.scale.y * self.flip.y,self.w/2,self.h/2) -- yay! we are drawing the foe
	--love.graphics.rectangle("line", self.pos.x,self.pos.y,self.w,self.h)
end

function Enemy:animate(anim_name)
	if self.current_anim ~= anim_name and self.animations[anim_name] ~= nil then
		self.animations[anim_name]:reset()
		self.animations[anim_name]:set(self.quad)
		self.current_anim = anim_name
	end
end

function Enemy:flip_h(flip)
	if flip then
		self.flip.x = -1
	else
		self.flip.x = 1
	end
end

function Enemy:flip_v(flip)
	if flip then
		self.flip.y = -1
	else
		self.flip.y = 1
	end
end

function Enemy:animation_finished()
	if self.animations[self.current_anim] ~= nil then
		return self.animations[self.current_anim].done
	end
	return false
end

function Enemy:add_animation(name, anim) -- new animation type
	self.animations[name] = anim
end

function Enemy:die()
	self.dead = true
end

return Enemy	