-- Player class

Class = require "hump.class"
Assets = require 'assets'
Util = require 'util'

Player = Class {
	init = function(self, sprite)
		self.sprite = sprite
		self.x = love.graphics.getWidth() / 2
		self.y = love.graphics.getHeight() / 2
		self.defaultSpeed = 180
		self.speed = defaultSpeed
		self.rotation = 0
		self.injured = false
	end
}

function Player:reset()
	self.x = love.graphics.getWidth() / 2
	self.y = love.graphics.getHeight() / 2
	self.speed = self.defaultSpeed
	self.injured = false
end

function Player:update(dt)
	self:keyboardPolling(dt)
	self:updateFacing();
end

function Player:updateFacing()
	self.rotation = Util.angleBetweenPoints(
			love.mouse.getX(), love.mouse.getY(), self.x, self.y)
end

function Player:keyboardPolling(dt)
	if love.keyboard.isDown("d")
			and self.x < love.graphics.getWidth() then
		self:move(1, 0, dt)
	end
	if love.keyboard.isDown("a") and self.x > 0 then
		self:move(-1, 0, dt)
	end
	if love.keyboard.isDown("w") and self.y > 0 then
		self:move(0, -1, dt)
	end
	if love.keyboard.isDown("s")
			and self.y < love.graphics.getHeight() then
		self:move(0, 1, dt)
	end
end

function Player:move(moveX, moveY, dt)
	self.x = self.x + (moveX * self.speed) * dt
	self.y = self.y + (moveY * self.speed) * dt
end

function Player:fire()
	-- Bullet 1 position (offset x, y from player)
	local ox, oy = Util.rotatePoint(
		0, - self.sprite:getHeight() * 0.38, self.rotation)
	Bullets.spawn(Assets.sprites.bullet,
		self.x + ox, self.y + oy, self.rotation)

	-- Bullet 2 position (offset x, y from player)
	ox, oy = Util.rotatePoint(
		0, self.sprite:getHeight() * 0.42, self.rotation)
	Bullets.spawn(Assets.sprites.bullet,
		self.x + ox, self.y + oy, self.rotation)

	Assets.sounds.gunshot:clone():play()
end

function Player:draw()
	if self.injured then
		love.graphics.setColor(1, 0.5, 0.5)
	end
	love.graphics.draw(self.sprite, self.x, self.y,
		self.rotation, nil, nil,
		self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
	love.graphics.setColor(1, 1, 1)
end

function Player:getRotation()
	return self.rotation
end

return Player

