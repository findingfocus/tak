Board = Class{}

function Board:init()
	self.x = 0
	self.width = 144 * 5
	self.height = 144 * 5
end

function Board:update(dt)

end

function Board:render()
	--BACKGROUND
	--love.graphics.setColor(200/255, 124/255, 73/255, 255/255)
	--love.graphics.rectangle('fill', X_OFFSET, 0 + Y_OFFSET, self.width, self.height)
    love.graphics.draw(boardOption1, 0, 0)
    love.graphics.setColor(0/255, 0/255, 0/255, 125/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	--HORIZONTAL LINES FOR GRID
    --[[
	love.graphics.setColor(100/255, 50/255, 8/255, 255/255)
	love.graphics.rectangle('fill', X_OFFSET, 0 + Y_OFFSET, 720, 12)
	for i = 1, 4 do
		love.graphics.rectangle('fill', X_OFFSET, 144 * i - 12 + Y_OFFSET, 720, 24)
	end
	love.graphics.rectangle('fill', X_OFFSET, 144 * 5 - 12 + Y_OFFSET, 720, 12)

	--VERTICAL LINES FOR GRID
	love.graphics.rectangle('fill', X_OFFSET, 0 + Y_OFFSET, 12, 720)
	for i = 1, 4 do
		love.graphics.rectangle('fill', X_OFFSET + 144 * i - 12, 0 + Y_OFFSET, 24, 720)
	end
	love.graphics.rectangle('fill', X_OFFSET + 144 * 5 - 12, 0 + Y_OFFSET, 12, 720)
    --]]
end
