local class = require("class")
local Menu = class:derive("Menu")

local m

function Menu:new(score)
	-- love.graphics.setBackgroundColor( 255, 255, 255 )
    love.graphics.setFont(love.graphics.newFont(18))
	love.graphics.setDefaultFilter('nearest','nearest')
	title = love.graphics.newImage("assets/gfx/Last_Stand.png")
	text = "< PRESS SPACE >"
	self.score = score
	if self.score then
		if self.score > best_score then
			best_score = self.score
		end
	end
	
	randomMap = {"fr","pr","gb","ru"}
	sfx_menu = love.audio.newSource("assets/sfx/menu.mp3","static")
	sfx_menu:setLooping(true)
	love.audio.play(sfx_menu)
end

function Menu:update()
	if love.keyboard.isDown("space") then
		m = randomMap[love.math.random(1,4)]
		change_state("Game",m)
	end
	if love.keyboard.isDown("escape") and current_state == "Menu" then
		love.event.quit()
	end
	if love.keyboard.isDown("q") and current_state == "Menu" then
		love.event.quit()
	end
	if love.keyboard.isDown("f") then -- f like forest [France]
		change_state("Game","fr")
	end
	if love.keyboard.isDown("g") then -- g like "góra" (pol. mountain) [Prussia]
		change_state("Game","pr")
	end
	if love.keyboard.isDown("h") then -- h like harbour therfore coast [Britain]
		change_state("Game","gb")
	end
	if love.keyboard.isDown("j") then -- j like jolly therfore winter [Russia]
		change_state("Game","ru")
	end
end

function Menu:draw()
	if self.score then
		love.graphics.print("Current score: " .. self.score,300,300)
		love.graphics.print("Best score:    " .. best_score,300,350)
	end
	-- if there is score
	-- then print score
	love.graphics.setColor(255,255,255)
	love.graphics.draw(title,155,100,0,7,7)
	love.graphics.print( text, 300, 400 )
	love.graphics.setColor(255,255,255)
end

return Menu