PlayState = Class{__includes = BaseState}

function PlayState:init()
	board = Board()
	grid = {}
	for i = 1, 5 do
		grid[i] = {}
		for j = 1, 5 do
			--Populates Grid Table with proper x and y fields and Occupant Object
			grid[i][j] = Occupant()
			grid[i][j].x = j * 144 - 144
			grid[i][j].y = i * 144 - 144
		end
	end
	mouseXGrid = 0
	mouseYGrid = 0
	player = 1
end

function PlayState:update(dt)
	mouseX, mouseY = love.mouse.getPosition()
	mouseMasterX, mouseMasterY = love.mouse.getPosition()

	--shifts mouseY to be top of grid, need to test on 16:9 monitor
	mouseY = mouseY - Y_OFFSET
	mouseX = mouseX - X_OFFSET
	--mouseMasterY = mouseMasterY - 40

	if mouseY < 0 or mouseY > 720 or mouseX < X_OFFSET or mouseX > 720 then
		mouseY = nil
		mouseX = nil
	end

	--Math to find which Row mouse is in
	if mouseY ~= nil then
		if mouseY / 144 < 1 then
			mouseYGrid = 1
		elseif mouseY / 144 < 2 then
			mouseYGrid = 2
		elseif mouseY / 144 < 3 then
			mouseYGrid = 3
		elseif mouseY / 144 < 4 then
			mouseYGrid = 4
		elseif mouseY / 144 < 5 then
			mouseYGrid = 5
		end
	else
		mouseYGrid = nil
	end	

	--Math to find which Column mouse is in
	if mouseX ~= nil then
		if mouseX / 144 < 1 then
			mouseXGrid = 1
		elseif mouseX / 144 < 2 then
			mouseXGrid = 2
		elseif mouseX / 144 < 3 then
			mouseXGrid = 3
		elseif mouseX / 144 < 4 then
			mouseXGrid = 4
		elseif mouseX / 144 < 5 then
			mouseXGrid = 5
		end
	else
		mouseXGrid = nil
	end

	for i = 1, 5 do
		for j = 1, 5 do
			if mouseXGrid == j and mouseYGrid == i then
				grid[i][j].highlighted = true
			else
				grid[i][j].highlighted = false
			end
		end
	end

	function love.mousepressed(x, y, button)
		if button == 1 and mouseXGrid ~= nil and mouseYGrid ~= nil then
			if not grid[mouseYGrid][mouseXGrid].occupied then
				sounds['stone']:play()
				if player == 1 then
					grid[mouseYGrid][mouseXGrid].occupied = true
					grid[mouseYGrid][mouseXGrid].occupiedWhite = true
				elseif player == 2 then
					grid[mouseYGrid][mouseXGrid].occupied = true
					grid[mouseYGrid][mouseXGrid].occupiedBlack = true
				end
				player = player == 1 and 2 or 1
			end
		end
	end
end


function PlayState:render()

	love.graphics.clear(80/255, 80/255, 80/255, 255/255)
	board:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.setFont(pixelFont)
	love.graphics.print('TAK', VIRTUAL_WIDTH - 400, 40)
	love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
	love.graphics.setFont(smallPixelFont)
	love.graphics.print('mouseX: ' .. tostring(mouseX), VIRTUAL_WIDTH - 400, 250)
	love.graphics.print('mouseY: ' .. tostring(mouseY), VIRTUAL_WIDTH - 400, 300)

	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. ']', VIRTUAL_WIDTH - 400, 400)
	
	--Render Mouse Grid Highlight
	for i = 1, 5 do
		for j = 1, 5 do
			--Render Grid Highlight if not occupied
			if grid[i][j].highlighted then
				grid[i][j]:render()
			end

			--Renders white stones
			if grid[i][j].occupiedWhite then
				grid[i][j]:render()
			end

			--Renders black stones
			if grid[i][j].occupiedBlack then
				grid[i][j]:render()
			end
		end
	end

	--Renders stone to mouse location
	if player == 1 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	elseif player == 2 then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
	end
	love.graphics.rectangle('fill', mouseMasterX - 60, mouseMasterY - 60, 120, 120)



	--Renders Player Turn
	if player == 1 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.print('It is White\'s move', 45, VIRTUAL_HEIGHT - 38)
	elseif player == 2 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.print('It is Black\'s move', 45, VIRTUAL_HEIGHT - 38)
	end

end