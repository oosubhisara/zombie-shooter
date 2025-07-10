-- hud.lua

Timer = require 'lib.hump.timer'
Class = require 'lib.hump.class'

local Hud = Class {
	init = function(self)
		self.score = 0
		self.highscore = 0
		self.messageText = ''
		self.toggleState = true
		self.toggleTimer = Timer.every(1.0, function()
			self.toggleState = false
			Timer.after(0.25, function()
				self.toggleState = true
			end)
		end)

	end
}

function Hud:reset()
	self.score = 0
end

function Hud:update(gameState, player, dt)
	Timer.update(dt)

	if gameState == GameState.TITLE then
		self.messageText = 'Press SPACE to start'
	elseif gameState == GameState.PLAYING and player.injured then
		self.messageText = 'Injured!'
	elseif gameState == GameState.GAMEOVER then
		self.messageText = 'Game over!'
	else
		self.messageText = ''
	end
end

function Hud:draw()
	self:drawStatusBar()
	self:drawMessageText()
end

function Hud:updateScore(amount)
	self.score = self.score + amount
	if self.score > self.highscore then
		self.highscore = self.score
	end
end

------------------------------------------------------------------------------
-- Functions to draw texts
------------------------------------------------------------------------------
function Hud:drawMessageText()
	love.graphics.setFont(Assets.messageFont)
	if self.toggleState then
		love.graphics.printf(self.messageText,
			0, love.graphics.getHeight() - 50,
			love.graphics.getWidth(), "center")
	end
end

function Hud:drawStatusBar()
	local width = love.graphics.getWidth() / 3
	love.graphics.setFont(Assets.statusFont)
	love.graphics.printf("Score: " .. self.score, 10, 10, width, "left")
	love.graphics.printf("Zombies: " .. Zombies.getCount(),
		width, 10, width, "center")
	love.graphics.printf("High score: " .. self.highscore, width * 2, 10,
		width - 10, "right")
end


local hud = Hud()

return hud
