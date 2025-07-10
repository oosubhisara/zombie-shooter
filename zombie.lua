-- Zombie class

Class = require "hump.class"
Signal = require 'hump.signal'
Util = require 'util'

Zombie = Class {
	init = function(self, sprite)
		self.sprite = sprite
		self.x = 0
		self.y = 0
		self.speed = 30
		self.dead = false
		self.facing = 0
		self:randomSpawnPosition()
	end
}

function Zombie:randomSpawnPosition()
	local side = math.random(1, 4)

	if side == 1 then
		self.x = -30
		self.y = math.random(0, love.graphics.getHeight())
	elseif side == 2 then
		self.x = love.graphics.getWidth() + 30
		self.y = math.random(0, love.graphics.getHeight())
	elseif side == 3 then
		self.x = math.random(0, love.graphics.getWidth())
		self.y = -30
	elseif side == 4 then
		self.x = math.random(0, love.graphics.getWidth())
		self.y = love.graphics.getHeight() + 30
	end
end

function Zombie:chase(target, dt)
	self:turnToTarget(target)
	self.x = self.x + math.cos(self.facing) * self.speed * dt
	self.y = self.y + math.sin(self.facing) * self.speed * dt
	if self:checkCollision(target) then
		Signal.emit('zombieHitTarget', self, target)
	end
end

function Zombie:checkCollision(other)
	return Util.distanceBetween(self.x, self.y, other.x, other.y) < 30
end

function Zombie:turnToTarget(target)
	self.facing = math.atan2(target.y - self.y, target.x - self.x)
end

function Zombie:die()
	self.dead = true
end

function Zombie:draw()
	love.graphics.draw(self.sprite, self.x, self.y,
		self.facing, nil, nil,
		self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

------------------------------------------------------------------------------
-- Zombie management functions
------------------------------------------------------------------------------

local zombies = {}
local initialMaxTime = 2.0
local maxTime = initialMaxTime
local timer = maxTime
local M = {} -- module table

function M.getCount()
	return #zombies
end

function M.reset()
	for i, z in ipairs(zombies) do
		zombies[i] = nil
	end

	maxTime = initialMaxTime
	timer = maxTime
end

function M.spawn(dt, sprite)
	timer = timer - dt
	if timer <= 0 then

		-- Create new zombie
		print("Spawning new zombie!")
		local zombie = Zombie(sprite)
		table.insert(zombies, zombie)

		-- Make next spawn time faster
		maxTime = maxTime - 0.1
		if maxTime < 0.5 then
			maxTime = 0.5
		end
		timer = maxTime
	end

end

function M.chase(target, dt)
	for i, zombie in ipairs(zombies) do
		zombie:chase(target, dt)
	end
end

function M.draw()
	for i, zombie in ipairs(zombies) do
		zombie:draw()
	end
end

function M.commitRemove()
	for i = #zombies, 1, -1 do
		local z = zombies[i]
		if z.dead then
			print("Remove dead zombie #" .. i)
			table.remove(zombies, i)
		end
	end
end

function M.forEach(fn)
	for i, zombie in ipairs(zombies) do
		fn(zombie)
	end
end

return M

