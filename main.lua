local const = require("const")
local movement = require("movement")
local input = require("input")

local gameState = const.gameState.menu
local score = const.score.initialScore
local background, player, pipes, audio

local function startGame()
	gameState = const.gameState.play
	score = const.score.initialScore

	player.x = const.player.initialPositionX
	player.y = const.player.initialPositionY
	player.gravity = const.physics.initialGravity

	pipes.top.x = const.pipes.positionX
	pipes.top.y = const.pipes.topInitialY

	pipes.bottom.x = const.pipes.positionX
	pipes.bottom.y = const.pipes.bottomInitialY
end

local function drawGame()
	-- Background
	love.graphics.draw(background.backgroundDaySprite, 0, 0)

	-- Player
	love.graphics.draw(
		player.sprite,
		player.x,
		player.y,
		0,
		const.player.size / player.sprite:getWidth(),
		const.player.size / player.sprite:getHeight()
	)

	-- Pipes
	love.graphics.draw(pipes.greenPipeInvertedSprite, pipes.top.x, pipes.top.y)
	love.graphics.draw(pipes.greenPipeSprite, pipes.bottom.x, pipes.bottom.y)

	-- Base (bottom aligned)
	local baseY = love.graphics.getHeight() - background.baseSprite:getHeight()
	love.graphics.draw(background.baseSprite, 0, baseY)

	-- Score
	love.graphics.print("Score: " .. score, 10, 10)
end

function love.load()
	gameState = const.gameState.menu

	background = {
		baseSprite = love.graphics.newImage("assets/sprites/base.png"),
		backgroundDaySprite = love.graphics.newImage("assets/sprites/background-day.png"),
	}

	player = {
		sprite = love.graphics.newImage("assets/sprites/batcat.jpeg"),
		x = const.player.initialPositionX,
		y = const.player.initialPositionY,
		gravity = 0,
	}

	pipes = {
		greenPipeSprite = love.graphics.newImage("assets/sprites/pipe-green.png"),
		greenPipeInvertedSprite = love.graphics.newImage("assets/sprites/pipe-green-inverted.png"),
		top = {
			x = const.pipes.positionX,
			y = const.pipes.topInitialY,
		},
		bottom = {
			x = const.pipes.positionX,
			y = const.pipes.bottomInitialY,
		},
	}

	audio = {
		dieSource = love.audio.newSource("assets/audio/die.ogg", "static"),
		pointSource = love.audio.newSource("assets/audio/point.ogg", "static"),
		wingSource = love.audio.newSource("assets/audio/wing.ogg", "static"),
	}
end

function love.update(dt)
	if gameState ~= const.gameState.play and input.isStartPressed() then
		startGame()
	end

	if gameState == const.gameState.play then
		movement.movePlayer(player, audio)
		score = score + movement.movePipes(pipes, audio)
		if movement.isPlayerCollided(player, pipes, audio, background) then
			gameState = const.gameState.gameOver
		end
	end
end

function love.draw()
	if gameState == const.gameState.menu then
		love.graphics.draw(background.backgroundDaySprite, 0, 0)
		love.graphics.printf(
			"Presiona ENTER para jugar",
			0,
			love.graphics.getHeight() / 2,
			love.graphics.getWidth(),
			"center"
		)
	elseif gameState == const.gameState.play then
		drawGame()
	elseif gameState == const.gameState.gameOver then
		drawGame() -- Draw last frame before game over
		love.graphics.printf(
			"GAME OVER\nPresiona ENTER para reiniciar",
			0,
			love.graphics.getHeight() / 2,
			love.graphics.getWidth(),
			"center"
		)
	end
end
