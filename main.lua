-- files needed for proper functioning --
Menu = require("Menu")
Game = require("Game")
Keyboard = require("Keyboard")

function love.load()
	best_score = 0
	current_state = nil
	change_state("Menu")
	-- -- KEYBOARD --
	-- Keyboard:hook_love_events()
end
 
function love.update(dt)
	if dt > 0.400 then return end -- this little bit of code helps to freeze the game when you start moving the window (!important)
	-- Keyboard:update(dt)
	current_state:update(dt)
end
 
function love.draw()
	current_state:draw()
end

function change_state(state, ...)
	current_state = _G[state](...)
end