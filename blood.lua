-- Blooc class

Class = require "lib.hump.class"
Signal = require 'lib.hump.signal'
Util = require 'util'

Blood = Class {
	init = function(self, sprite, x, y)
		self.sprite = sprite
		self.spriteIndex = math.random(0, 3)
		self.x = x
		self.y = y
		self.lifetime = 30
		self.exists = true
	end
}

function Blood:update(dt)
	self.lifetime = self.lifetime - dt
	if self.lifetime <= 0 then
		self.lifetime = 0
		self.exists = false
	end
end

function Blood:draw()
	local quad = love.graphics.newQuad(
		0, 32 * self.spriteIndex, 32, 32, self.sprite)
	love.graphics.draw(self.sprite, quad, self.x, self.y,
		nil, nil, nil, 16, 16)
end

------------------------------------------------------------------------------
-- Blood management functions
------------------------------------------------------------------------------

local M = {} -- module table
local bloods = {}

function M.reset()
	for i, b in ipairs(bloods) do
		bloods[i] = nil
	end
end

function M.spawn(sprite, x, y)
	local blood = Blood(sprite, x, y)
	table.insert(bloods, blood)
end

function M.update(dt)
	for i, blood in ipairs(bloods) do
		blood:update(dt)
	end
end

function M.draw()
	for i, blood in ipairs(bloods) do
		blood:draw()
	end
end

function M.commitRemove()
	for i = #bloods, 1, -1 do
		local b = bloods[i]
		if not b.exists then
			table.remove(bloods, i)
		end
	end
end

return M

