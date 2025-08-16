local windowBase, windowHeight = love.window.getDesktopDimensions()
local scale = 0.8

local config = {
	resolution = {
		originalBase = 288,
		originalHeight = 512,
		windowHeight = windowHeight * scale,
		windowWidth = windowBase * scale,
	},

	gameState = { menu = 1, play = 2, gameOver = 3 },

	player = {
		initialPositionX = 100,
		initialPositionY = 200,
		size = 50,
	},

	score = { initialScore = 0, scoreIncrement = 1 },

	physics = {
		initialGravity = 0,
		maxGravity = 4,
		gravityDecrement = 0.1,
		impulse = -2,
	},

	pipes = {
		velocity = 2,
		positionX = 500,
		length = 320,
		width = 52,
		respawnX = -52,
		topInitialY = -150,
		bottomInitialY = 300,
		verticalMovement = 150,
	},

	screen = {
		topBorder = 0,
	},
}

return config
