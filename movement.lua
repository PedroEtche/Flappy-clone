local const = require("const")
local input = require("input")

local movement = {}

function movement.movePlayer(player, audio)
	if input.isJumpPressed() then
		player.gravity = const.physics.impulse
		audio.wingSource:play()
	elseif player.gravity < const.physics.maxGravity then
		player.gravity = player.gravity + const.physics.gravityDecrement
	end

	player.y = player.y + player.gravity
end

local function calculateNewPipesPosition(pipes)
	pipes.top.x = const.pipes.positionX
	pipes.bottom.x = const.pipes.positionX

	local offset = math.random(0, const.pipes.verticalMovement)
	pipes.top.y = const.pipes.topInitialY - offset
	pipes.bottom.y = const.pipes.bottomInitialY - offset
end

function movement.movePipes(pipes, audio)
	pipes.top.x = pipes.top.x - const.pipes.velocity
	pipes.bottom.x = pipes.bottom.x - const.pipes.velocity

	if pipes.top.x < const.pipes.respawnX and pipes.bottom.x < const.pipes.respawnX then
		calculateNewPipesPosition(pipes)
		audio.pointSource:play()
		return 1
	end
	return 0
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
local function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function movement.isPlayerCollided(player, pipes, audio, background)
	local baseY = love.graphics.getHeight() - background.baseSprite:getHeight()
	if
		checkCollision(
			player.x,
			player.y,
			const.player.size,
			const.player.size,
			pipes.top.x,
			pipes.top.y,
			const.pipes.width,
			const.pipes.length
		)
		or checkCollision(
			player.x,
			player.y,
			const.player.size,
			const.player.size,
			pipes.bottom.x,
			pipes.bottom.y,
			const.pipes.width,
			const.pipes.length
		)
		or player.y <= const.screen.topBorder
		or player.y + const.player.size >= baseY
	then
		audio.dieSource:play()
		return true
	end
	return false
end

return movement
