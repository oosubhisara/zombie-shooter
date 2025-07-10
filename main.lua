Assets = require 'assets'
Player = require 'player'
Zombies = require 'zombie'
Bullets = require 'bullet'
Bloods = require 'blood'
Hud = require 'hud'
Signal = require 'lib.hump.signal'
Util = require 'util'

GameState = { TITLE = 1, PLAYING = 2, GAMEOVER =3 }
local sprites = {}
local player

------------------------------------------------------------------------------
-- LOVE callback functions
------------------------------------------------------------------------------
function love.load()
	math.randomseed(os.time())

	Assets:load()
	player = Player(Assets.sprites.player)

	Signal.register('zombieHitTarget', zombieHitTarget)
	Signal.register('bulletHitZombie', bulletHitZombie)

	resetGame()
end

function love.update(dt)
	Hud:update(gameState, player, dt)

	if gameState == GameState.PLAYING then
		player:update(dt)
		Zombies.spawn(dt, Assets.sprites.zombie)
		Zombies.chase(player, dt)
		Bullets.update(dt)
		Bloods.update(dt)

		Zombies.commitRemove()
		Bullets.commitRemove()
		Bloods.commitRemove()
	end
end

function love.draw()
	if gameState == GameState.GAMEOVER then
		love.graphics.setColor(0.5, 0.5, 0.5)
	end
	love.graphics.draw(Assets.sprites.background, 0, 0)

	love.graphics.setColor(1.0, 1.0, 1.0)
	Bloods.draw()
	player:draw()
	Zombies.draw()
	Bullets.draw()
	Hud:draw()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif gameState == GameState.TITLE and key == "space" then
		gameState = GameState.PLAYING
		Assets.sounds.zombieLoop:setVolume(0.5)
		Assets.sounds.zombieLoop:play()
	end
end

function love.mousepressed(x, y, button)
	if button == 1 then
		if gameState == GameState.PLAYING then
			player:fire()
		end
	end
end

------------------------------------------------------------------------------
-- Signal callbacks
------------------------------------------------------------------------------
function zombieHitTarget(zombie, target)
	print("Hit!")
	zombie.dead = true
	if not target.injured then
		target.injured = true
		target.speed = target.speed * 1.7
	else
		gameState = GameState.GAMEOVER
		Timer.after(5, function() resetGame() end)
		return
	end
end

function bulletHitZombie(bullet, zombie)
	Assets.sounds.impact:clone():play()
	zombie:die()
	Bloods.spawn(Assets.sprites.blood, zombie.x, zombie.y)
	bullet.dead = true
	Hud:updateScore(10)
end

------------------------------------------------------------------------------
-- Functions to reset game states
------------------------------------------------------------------------------
function resetGame()
	print("Reseting game")
	gameState = GameState.TITLE
	player:reset()
	Zombies.reset()
	Bullets.reset()
	Bloods.reset()
	Hud:reset()
	Assets.sounds.zombieLoop:stop()
end

