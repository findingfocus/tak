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
    love.graphics.draw(boardOption1, 0, 0)
    love.graphics.setColor(0/255, 0/255, 0/255, 125/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
