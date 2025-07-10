-- Bullet class

Class = require 'lib.hump.class'

local M = {}
local bullets = {}

Bullet = Class {
	init = function(self, sprite, x, y, angle)
		self.sprite = sprite
		self.x = x
		self.y = y
		self.speed = 600
		self.direction = angle
		self.dead = false
	end
}

function M.reset()
	for i, b in ipairs(bullets) do
		bullets[i] = nil
	end
end

function M.spawn(sprite, x, y, angle)
	local bullet = Bullet(sprite, x, y, angle)
	table.insert(bullets, bullet)
end

function M.commitRemove()
	for i = #bullets, 1, -1 do
		local b = bullets[i]
		if b.dead then
			table.remove(bullets, i)
		end
	end
end

function M.update(dt)
	-- Move bullets
	for i, bullet in ipairs(bullets) do
		bullet.x = bullet.x + math.cos(bullet.direction) * bullet.speed * dt
		bullet.y = bullet.y + math.sin(bullet.direction) * bullet.speed * dt
	end

	-- Destroy offscreen bullets
	for i = #bullets, 1, -1 do
		if bullets[i].x < 0 or bullets[i].x > love.graphics.getWidth()
			or bullets[i].y < 0 or bullets[i].y > love.graphics.getHeight()
			then
			table.remove(bullets, i)
		end
	end

	-- Check collision with zombies
	Zombies.forEach(function(zombie)
		for j, bullet in ipairs(bullets) do
			if Util.distanceBetween(
				zombie.x, zombie.y, bullet.x, bullet.y) < 20 then
				Signal.emit('bulletHitZombie', bullet, zombie)
			end
		end
	end)
end

function M.draw()
	for i, b in ipairs(bullets) do
		love.graphics.draw(b.sprite, b.x, b.y,
			nil, 0.2, 0.2,
			b.sprite:getWidth() / 2, b.sprite:getHeight() / 2)
	end
end

return M

