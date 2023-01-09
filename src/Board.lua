Board = Class{}

function Board:init()
	self.x = 0
	self.width = 144 * 5
	self.height = 144 * 5
	self.yOffset = 40
end

function Board:update(dt)
	
end

function Board:render()
	--BACKGROUND
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.rectangle('fill', 0, 0 + self.yOffset, self.width, self.height)

	--HORIZONTAL LINES FOR GRID
	love.graphics.setColor(120/255, 100/255, 90/255, 255/255)
	love.graphics.rectangle('fill', 0, 0 + self.yOffset, 720, 12)

	love.graphics.rectangle('fill', 0, 144 - 12 + self.yOffset, 720, 24)

	love.graphics.rectangle('fill', 0, 144 * 2 -12 + self.yOffset, 720, 24)

	love.graphics.rectangle('fill', 0, 144 * 3 -12 + self.yOffset, 720, 24)

	love.graphics.rectangle('fill', 0, 144 * 4 -12 + self.yOffset, 720, 24)

	love.graphics.rectangle('fill', 0, 144 * 5 -12 + self.yOffset, 720, 12)

	--VERTICAL LINES FOR GRID
	love.graphics.rectangle('fill', 0, 0 + self.yOffset, 12, 720)

	love.graphics.rectangle('fill', 144 - 12, 0 + self.yOffset, 24, 720)

	love.graphics.rectangle('fill', 144 * 2 - 12, 0 + self.yOffset, 24, 720)

	love.graphics.rectangle('fill', 144 * 3 - 12, 0 + self.yOffset, 24, 720)

	love.graphics.rectangle('fill', 144 * 4 - 12, 0 + self.yOffset, 24, 720)

	love.graphics.rectangle('fill', 144 * 5 - 12, 0 + self.yOffset, 12, 720)
end