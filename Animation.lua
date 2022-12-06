-- files needed for proper functioning --
local class = require("class")
local Anim = class:derive("Animation")
local Vector2 = require("Vector2")


function Anim:new(xoffset, yoffset, w, h, num_frames, column_size, fps, loop)
	self.fps = fps
	self.num_frames = num_frames
	self.column_size = column_size
	self.start_offset = Vector2(xoffset, yoffset)
	self.offset = Vector2()
	self.size = Vector2(w, h)
	-- loop = false, playthrough once, otherwise, loop forever
	self.loop = loop == nil or loop
	self.done = false
	self:reset()
end

function Anim:update(dt, quad)
	--print( self.frame .. " | " .. self.offset.x .. " | " .. self.offset.y) -- leave it be! need this for debugging
	if self.num_frames <= 1 then 
		return
	elseif self.timer > 0 then
		self.timer = self.timer - dt -- animation timer that doesn't work half of the time
		if self.timer <= 0 then
			self.timer = 1/self.fps
			self.frame = self.frame + 1
			if self.frame > self.num_frames then
				if self.loop then
					self.frame = 1
				else
					self.frame = self.num_frames
					self.timer = 0
					self.done = true
				end
			end
			self.offset.x = self.start_offset.x + (self.size.x * ((self.frame - 1) % (self.column_size))) -- I have no idea what I meant so make sure you will leave it as it is
			self.offset.y = self.start_offset.y + (self.size.y * math.floor((self.frame - 1)/self.column_size)) -- same
			quad:setViewport(self.offset.x,self.offset.y,self.size.x,self.size.y) -- setting the viewport for a quad, duh
		end
	end
end

function Anim:reset()
	self.timer = 1/self.fps
	self.frame = 1
	self.done = false
	self.offset.x = self.start_offset.x
	self.offset.y = self.start_offset.y
end

function Anim:set(quad)
	-- self:reset()
	quad:setViewport(self.offset.x, self.offset.y, self.size.x, self.size.y)
end

return Anim