PlayState = Class{__includes = BaseState}

function PlayState:init()
	board = Board()
end

function PlayState:update(dt)

end


function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.print('TAK', VIRTUAL_WIDTH - 400, 40)
	board:render()
end 

