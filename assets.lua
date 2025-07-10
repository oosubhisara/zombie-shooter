-- asset.lua

Class = require 'hump.class'

local Assets = Class {
	sprites = {},
	sounds = {},
	statusFont = nil,
	messageFont = nil
}

function Assets:load()
	self.sprites.background = love.graphics.newImage('sprites/background.png')
	self.sprites.bullet = love.graphics.newImage('sprites/bullet.png')
	self.sprites.player = love.graphics.newImage('sprites/player.png')
	self.sprites.zombie = love.graphics.newImage('sprites/zombie.png')
	self.sprites.blood = love.graphics.newImage('sprites/blood_red.png')

	self.sounds.gunshot = love.audio.newSource('sounds/gunshot.mp3', 'static')
	self.sounds.impact = love.audio.newSource('sounds/impact.mp3', 'static')
	self.sounds.zombieLoop = love.audio.newSource('sounds/zombie_loop.ogg',
		'stream')

	self.sounds.gunshot:setVolume(0.1)
	self.sounds.impact:setVolume(0.3)
	self.sounds.zombieLoop:setLooping(true)

	self.statusFont = love.graphics.newFont(24)
	self.messageFont = love.graphics.newFont(30)
end

local assets = Assets()
return assets;
