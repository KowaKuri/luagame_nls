-- THIS FILE IS IMPORTANT FOR CORRECT FUNCTIONING OF THE CODE --
local Class = {}
Class.__index = Class

-- default implementation
function Class:new() 
	print("new from base")
end

-- Create a new class from our base class
function Class:derive(type)
	local cls = {}
	cls["__call"] = Class.__call
	cls.type = type
	cls.__index = cls
	cls.base = self
	setmetatable(cls, self)
	return cls
end

function Class:__call(...)
	local inst = setmetatable({},self)
	inst:new(...)
	return inst
end

function Class:get_type()
	return self.type
end

return Class