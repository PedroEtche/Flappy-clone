local input = {}

function input.isJumpPressed()
	return love.keyboard.isDown("space")
end

function input.isStartPressed()
	return love.keyboard.isDown("return")
end

return input
