-- Replacing the main -- 
local class = require("class")
local Game = class:derive("Game")
local Keyboard = require("Keyboard")
local Anim = require("Animation")
local Player = require("Player")
local Enemy = require("Enemy")
local Bullet = require("Bullet")
local wf = require("libraries/windfield")

local hero -- player spritesheet
local foe -- enemy spritesheet

local player -- player class
local enemy -- Enemy class
local bullet -- bullet class
local timer = 0
local at = 0 -- appearence time
local idle = Anim(0,0,18,18,2,2,1) -- Anim(x,y,w,h,num_columns,num_frames,speed,loop) aka animation starting parameters
local walk = Anim(18,18,18,18,2,2,6,false)
local charge = Anim(18,18,18,18,2,2,4)
local reload = Anim(0,36,18,18,4,4,5,false)
local fire = Anim(0,54,18,18,5,5,4,false)
local life

function Game:new(choice)
	-- COLISIONS --
	world = wf.newWorld(0, 0, true)
	world:addCollisionClass("Player")
	world:addCollisionClass("Enemy", {ignores = {"Enemy"}})
	world:addCollisionClass("Bullet")
	
	-- KEYBOARD --
	Keyboard:hook_love_events()
	
	-- GRAPHICS --
	fontik = love.graphics.newFont(18)
	love.graphics.setDefaultFilter('nearest','nearest') -- This bit is making pixels more pixel-ish
	hero = love.graphics.newImage("assets/gfx/poland.png") -- Uploading the player sheet (It has all pictures of animations)
	
	-- MAPS --
	local choice = choice
	if choice == "fr" then
		foe = love.graphics.newImage("assets/gfx/france.png")
		map = love.graphics.newImage("assets/gfx/forest.png")
		sfx_walk = love.audio.newSource("assets/sfx/leaves.ogg","static")
		sfx_music = love.audio.newSource("assets/sfx/french_march.mp3","static")
		sfx_music:setVolume(0.5)
	elseif choice == "pr" then
		foe = love.graphics.newImage("assets/gfx/prussia.png")
		map = love.graphics.newImage("assets/gfx/mountain.png")
		sfx_walk = love.audio.newSource("assets/sfx/leaves.ogg","static")
		sfx_music = love.audio.newSource("assets/sfx/prussian_march.mp3","static")
		sfx_music:setVolume(0.2)
	elseif choice == "gb" then
		foe = love.graphics.newImage("assets/gfx/britain.png")
		map = love.graphics.newImage("assets/gfx/coast.png")
		sfx_walk = love.audio.newSource("assets/sfx/leaves.ogg","static")
		sfx_music = love.audio.newSource("assets/sfx/british_march.mp3","static")
		sfx_music:setVolume(0.5)
	elseif choice == "ru" then
		foe = love.graphics.newImage("assets/gfx/russia.png")
		map = love.graphics.newImage("assets/gfx/winter.png")
		sfx_walk = love.audio.newSource("assets/sfx/steps_snow.ogg","static")
		sfx_music = love.audio.newSource("assets/sfx/russian_march.mp3","static")
		sfx_music:setVolume(0.5)
	else
		foe = love.graphics.newImage("assets/gfx/russia.png")
		map = love.graphics.newImage("assets/gfx/coast.png")
		sfx_walk = love.audio.newSource("assets/sfx/leaves.ogg","static")
		sfx_music = love.audio.newSource("assets/sfx/music.mp3","static")
		sfx_music:setVolume(0.5)
	end
	background = "map"
	
	-- PLAYER --
	-- player(name,x,y,w,h,postion_x,position_y,angle,scale_x,scale_y)
	player = Player(hero,0,0,18,18,100,400,0,6,6) -- here we are passing the parameters for player class
	bullets = {}
	
	-- ENEMY -- 
	enemies = {}
	
	-- ANIMATIONS --
	player:add_animation("idle", idle)
	player:add_animation("walk", walk) -- here we are passing the code of animation and animation starting parameter
	player:add_animation("reload", reload)
	player:add_animation("fire", fire)
	
	-- SOUND --
	sfx_fire = love.audio.newSource("assets/sfx/fire.mp3","static")
	sfx_reload = love.audio.newSource("assets/sfx/reload.wav","static")
	sfx_death = love.audio.newSource("assets/sfx/death.wav","static")
	sfx_pain = love.audio.newSource("assets/sfx/pain.wav","static")
	
	Game:reset()
	
	sfx_music:setLooping(true)
	love.audio.play(sfx_music)
end

function Game:update(dt)
	world:update(dt)
	timer = timer + dt
	
	-- HANDLING KEYBOARD --
	if Keyboard:key_down("space") and player.current_anim ~= "reload" then
		if player.current_anim ~= "fire" and player.current_anim ~= "reload" then
			bullet = Bullet(player.pos.x,player.pos.y)
			table.insert(bullets,bullet)
		end
		player:animate("fire")
		love.audio.play(sfx_fire)
		-- love.audio.setVolume( 1 )
	elseif Keyboard:key_down(",") then
		love.audio.stop(sfx_music)
	elseif Keyboard:key_down(".") then
		sfx_music:setLooping(true)
		love.audio.play(sfx_music)
	elseif Keyboard:key_down("escape") then
		change_state("Menu",score)
		Game:reset()
	end
	
	-- HANDLING ANIMATIONS --
	if player.current_anim == "fire" and player:animation_finished() then
		player:animate("reload")
	elseif player.current_anim == "reload" and player:animation_finished() then
		player:animate("idle")
	elseif player.current_anim == "walk" and player:animation_finished() then
		player:animate("idle")
	end
	
	-- WALKING --
	player.collider:setLinearVelocity(0, 0)
	if love.keyboard.isDown("w","up") and player.current_anim ~= "fire" and player.current_anim ~= "reload" then
		player:animate("walk")
		love.audio.play(sfx_walk)
		if player.pos.y > 350 then
			--player.pos.y = player.pos.y - 4
			player.collider:setLinearVelocity(0,-120)
		end
	end
	if love.keyboard.isDown("s","down") and player.current_anim ~= "fire" and player.current_anim ~= "reload" then
		player:animate("walk")
		love.audio.play(sfx_walk)
		if player.pos.y < 550 then
			--player.pos.y = player.pos.y + 4
			player.collider:setLinearVelocity(0,120)
		end
	end
	if love.keyboard.isDown("a","left") and player.current_anim ~= "fire" and player.current_anim ~= "reload" then
		player:animate("walk")
		love.audio.play(sfx_walk)
		-- player:flip_h(true)
		player:flip_h(false)
		if player.pos.x > 70 then
			player.collider:setLinearVelocity(-120, 0)
		end
	end
	if love.keyboard.isDown("d","right") and player.current_anim ~= "fire" and player.current_anim ~= "reload" then
		player:animate("walk")
		love.audio.play(sfx_walk)
		player:flip_h(false)
		if player.pos.x < 200 then
			player.collider:setLinearVelocity(120, 0)
		end
	end
	if love.keyboard.isDown("a","left") and love.keyboard.isDown("w","up") and player.current_anim ~= "fire" and player.current_anim ~= "reload" then
		player:animate("walk")
		love.audio.play(sfx_walk)
		if player.pos.x > 70 and player.pos.y > 350 then
			--player.pos.y = player.pos.y - 4
			player.collider:setLinearVelocity(-120,-120)
		end
	end
	if love.keyboard.isDown("a","left") and love.keyboard.isDown("s","down") and player.current_anim ~= "fire" and player.current_anim ~= "reload" then
		player:animate("walk")
		love.audio.play(sfx_walk)
		if player.pos.x > 70 and player.pos.y < 550 then
			--player.pos.y = player.pos.y + 4
			player.collider:setLinearVelocity(-120,120)
		end
	end
	if love.keyboard.isDown("d","right") and love.keyboard.isDown("w","up") and player.current_anim ~= "fire" and player.current_anim ~= "reload" then
		player:animate("walk")
		love.audio.play(sfx_walk)
		-- player:flip_h(true)
		player:flip_h(false)
		if player.pos.x < 200 and player.pos.y > 350 then
			player.collider:setLinearVelocity(120,-120)
		end
	end
	if love.keyboard.isDown("d","right") and love.keyboard.isDown("s","down") and player.current_anim ~= "fire" and player.current_anim ~= "reload" then
		player:animate("walk")
		love.audio.play(sfx_walk)
		player:flip_h(false)
		if player.pos.x < 200 and player.pos.y < 550 then
			player.collider:setLinearVelocity(120,120)
		end
	end
	
	Keyboard:update(dt)
	player:update(dt) -- calling player class update function
	for i = #enemies,1,-1 do
		enemy = enemies[i]
		--if enemy.appearence <= timer then
			enemy:update(dt)
		--end
	end
	for i = #bullets,1,-1 do
		bullet = bullets[i]
		if bullet.dissapeared == true then
			table.remove(bullets, i)
		else
			bullet:update()
		end
	end
	
		-- ENEMY ----------------------------------------------------------------------------------------------
	for i = #enemies,1,-1 do
		enemy = enemies[i]
		if enemy.pos.x > 0 then
			if enemy.hurt == true then
				enemy.collider:setLinearVelocity(-30, 0)
			else
				enemy.collider:setLinearVelocity(love.math.random(-80,-120), 0)
			end
			enemy:flip_h(true)
			if enemy.pos.x <= 800 then
				enemy:animate("charge")
				love.audio.play(sfx_walk)
			end
		else
			enemy.collider:destroy()
			table.remove(enemies, i)
			life = life - 25
		end
		if enemy.dead == true then
			enemy.collider:destroy()
			table.remove(enemies, i)
		end
	end
	
	if timer >= love.math.random(spawn_min,spawn_max) then
		local opponent = Enemy(foe,0,0,18,18,love.math.random(850,999),love.math.random(350,500),0,6,6, at)
		opponent:add_animation("charge", charge)
		table.insert(enemies, opponent)
		timer = 0
		spawn_count = spawn_count + 1
		if spawn_count >= spawn_level and spawn_count < 50 then
			spawn_level = spawn_level * 2
			level = level + 1
			if spawn_max > 5 then
				spawn_max = spawn_max - 1
				if spawn_min > 2 then
					spawn_min = spawn_min - 1
				end
			end
		end
		timer = 0
	end
	
	-- LIFE --
	if life <= 0 or player.life <= 0 then
		change_state("Menu",score)
		Game:reset()
	end
end

function Game:draw()
	if background == "map" then
		love.graphics.draw(map,0,0)
	end
	
	player:draw() -- calling player class draw function
	for i = #enemies,1,-1 do
		enemy = enemies[i]
		--if enemy.pos.x > 0 and enemy.appearence <= timer then
		if enemy.pos.x > 0 then
			enemy:draw() -- calling enemy class draw function
		end
	end
	for i = #bullets,1,-1 do
		bullet = bullets[i]
		if bullet.pos.x > player.pos.x + 40 then
			bullet:draw() -- calling bullet class draw function
		end
	end
	-- HEALTH --
	love.graphics.setColor(237,28,36)
	love.graphics.print("HEALTH",22,10,0,1,1,0,math.floor(fontik:getHeight()/2))
	love.graphics.rectangle("fill",100,9,48*(player.life/100),4)
	love.graphics.setColor(196,15,24)
	love.graphics.rectangle("line",100,9,48,4)
	-- ARMY --
	love.graphics.setColor(63,72,204)
	love.graphics.print("ARMY",22,25,0,1,1,0,math.floor(fontik:getHeight()/2))
	love.graphics.rectangle("fill",100,24,48*(life/100),4)
	love.graphics.setColor(43,51,159)
	love.graphics.rectangle("line",100,24,48,4)
	-- SCORE --
	love.graphics.setColor(235,242,0)
	love.graphics.print("SCORE",22,40,0,1,1,0,math.floor(fontik:getHeight()/2))
	love.graphics.print(score,100,40,0,1,1,0,math.floor(fontik:getHeight()/2))
	-- LEVEL --
	love.graphics.setColor(235,235,0)
	love.graphics.print("LEVEL",22,55,0,1,1,0,math.floor(fontik:getHeight()/2))
	love.graphics.print(level,100,55,0,1,1,0,math.floor(fontik:getHeight()/2))
	-- COLOUR RESET --
	love.graphics.setColor(255,242,255)
	-- world:draw() -- helper for colider debugging
end

function Game:reset()
	life = 100
	player.life = 100
	score = 0
	level = 1
	spawn_count = 0
	spawn_level = 5
	spawn_min = 6
	spawn_max = 10
	love.audio.stop(sfx_music)
	love.audio.stop(sfx_menu)
end

return Game