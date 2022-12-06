local class = require("class")
local Bullet = class:derive("Bullet")
local Vector2 = require("Vector2")

function Bullet:new(x, y) -- this function creates a new bullet (character)
	self.image = love.graphics.newImage("assets/gfx/bullet.png")
	self.pos = Vector2(x or 0, (y+10) or 0) -- screen position
	self.scale = Vector2(5,5) -- put it to 1
	self.collider = world:newRectangleCollider(self.pos.x,self.pos.y,6,6)
	self.collider:setCollisionClass("Bullet")
	self.collider:setFixedRotation(true)
	self.collider:setObject(self)
	self.dissapeared = false
end

function Bullet:update(dt)
	self.pos.x, self.pos.y = self.collider:getPosition()
	self.collider:setLinearVelocity(250, 0)
end

function Bullet:draw()
	love.graphics.draw(self.image,self.pos.x-4,self.pos.y-4,0,self.scale.x,self.scale.y) -- yay! we are drawing the foe
end

function Bullet:dissapear()
	self.collider:destroy()
	self.dissapeared = true
end

return Bullet