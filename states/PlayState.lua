PlayState = Class{__includes = BaseState}

function PlayState:init()
	board = Board()
	grid = {}
	mouseXGrid = 0
	mouseYGrid = 0
	player = 1
	player1stones = 21
	player1capstone = 1
	player2capstone = 1
	player2stones = 21
	stoneSelect = 1

	--POPULATES GRID TABLE WITH PROPER GRID X AND Y FILEDS AND OCCUPANT OBJECTS
	for i = 1, 5 do
		grid[i] = {}
		for j = 1, 5 do
			grid[i][j] = {}
			grid[i][j] = Occupant()
			grid[i][j].x = j * 144 - 144
			grid[i][j].y = i * 144 - 144
		end
	end
end

function PlayState:update(dt)
---[[MOUSE POSITION VARIABLES
	mouseMasterX, mouseMasterY = love.mouse.getPosition()
	mouseX, mouseY = love.mouse.getPosition()
	--SHIFTS MOUSE_X AND MOUSE_Y TO GRID COORDINATES RATHER THAN SCREEN COORDINATES
	mouseY = mouseY - Y_OFFSET
	mouseX = mouseX - X_OFFSET
--]]

---[[NILLIFY THE MOUSE COORDINATES IF OFF GRID
	if mouseY < 0 or mouseY > 720 or mouseX < X_OFFSET or mouseX > 720 then
		mouseY = nil
		mouseX = nil
	end
--]]

---[[ASSIGNS SELECTION LIMIT FOR PLAYERS
	if player1capstone == 1 then
		p1SelectLimit = 3
	else
		p1SelectLimit = 2
	end

	if player2capstone == 1 then
		p2SelectLimit = 3
	else
		p2SelectLimit = 2
	end
--]]

---[[GRID RESET
	if love.keyboard.wasPressed('r') then
		for i = 1, 5 do
			for j = 1, 5 do
				grid[i][j] = Occupant()
				grid[i][j].x = j * 144 - 144
				grid[i][j].y = i * 144 - 144
				player = 1
			end
		end
	end
--]]

---[[STONE SELECT
	if player == 1 then
		if love.keyboard.wasPressed('right') then
			sounds['beep']:play()
			if stoneSelect < p1SelectLimit then
				stoneSelect = stoneSelect + 1
			elseif stoneSelect == p1SelectLimit then
				stoneSelect = 1
			end
		end

		if love.keyboard.wasPressed('left') then
			sounds['beep']:play()
			if stoneSelect > 1 then
				stoneSelect = stoneSelect - 1
			elseif stoneSelect == 1 then
				stoneSelect = p1SelectLimit
			end
		end

	elseif player == 2 then
		if love.keyboard.wasPressed('right') then
			sounds['beep']:play()
			if stoneSelect < p2SelectLimit then
				stoneSelect = stoneSelect + 1
			elseif stoneSelect == p2SelectLimit then
				stoneSelect = 1
			end
		end

		if love.keyboard.wasPressed('left') then
			sounds['beep']:play()
			if stoneSelect > 1 then
				stoneSelect = stoneSelect - 1
			elseif stoneSelect == 1 then
				stoneSelect = p2SelectLimit
			end
		end
	end
--]]

---[[POPULATES MOUSE GRID WITH CURSOR LOCATION
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
--]]

---[[SETS SELECTION HIGHLIGHT TO TRUE IF UNDER MOUSE CURSOR
	for i = 1, 5 do
		for j = 1, 5 do
			if mouseXGrid == j and mouseYGrid == i then
				grid[i][j].selectionHighlight = true
			else
				grid[i][j].selectionHighlight = false
			end
		end
	end
--]]

---[[CLICK DETECTION
	function love.mousepressed(x, y, button)
		if button == 1 and mouseXGrid ~= nil and mouseYGrid ~= nil then --ENSURES WE CLICKED WITHIN GRID
			if not grid[mouseYGrid][mouseXGrid].occupied then --ENSURES STONE CANNOT BE PLACE IN OCCUPIED GRID
				sounds['stone']:play()
				if stoneSelect == 1 then --LAYSTONE PLACEMENT
					if player == 1 then
						player1stones = player1stones - 1
						grid[mouseYGrid][mouseXGrid].occupied = true
						grid[mouseYGrid][mouseXGrid].occupiedWhite = true
					elseif player == 2 then
						player2stones = player2stones - 1
						grid[mouseYGrid][mouseXGrid].occupied = true
						grid[mouseYGrid][mouseXGrid].occupiedBlack = true
					end
				elseif stoneSelect == 2 then --STANDING STONE PLACEMENT
					if player == 1 then
						player1stones = player1stones - 1
						grid[mouseYGrid][mouseXGrid].occupied = true
						grid[mouseYGrid][mouseXGrid].occupiedWhiteSS = true
					elseif player == 2 then
						player2stones = player2stones - 1
						grid[mouseYGrid][mouseXGrid].occupied = true
						grid[mouseYGrid][mouseXGrid].occupiedBlackSS = true
					end
				elseif stoneSelect == 3 then
					if player == 1 then
						player1capstone = 0
						grid[mouseYGrid][mouseXGrid].occupied = true 
						grid[mouseYGrid][mouseXGrid].occupiedWhiteCS = true
					elseif player == 2 then
						player2capstone = 0
						grid[mouseYGrid][mouseXGrid].occupied = true
						grid[mouseYGrid][mouseXGrid].occupiedBlackCS = true
					end
				end

				--SWAPS PLAYER
				player = player == 1 and 2 or 1
				stoneSelect = 1
			end
		end
	end
	--]]
end


function PlayState:render()

	love.graphics.clear(80/255, 80/255, 80/255, 255/255)
	board:render()
	
---[[RENDERS PLACED STONES
	for i = 1, 5 do
		for j = 1, 5 do
			--RENDERS GRID HIGHLIGHT IF NOT OCCUPIED
			if grid[i][j].selectionHighlight and not grid[i][j].occupied then
				grid[i][j]:render()
			end

			--RENDERS WHITE STONES
			if grid[i][j].occupiedWhite or grid[i][j].occupiedWhiteSS or grid[i][j].occupiedWhiteCS then
				grid[i][j]:render()
			end

			--RENDERS BLACK STONES
			if grid[i][j].occupiedBlack or grid[i][j].occupiedBlackSS or grid[i][j].occupiedBlackCS then
				grid[i][j]:render()
			end
		end
	end
--]]

---[[RENDERS STONE SELECTION
	if player == 1 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	elseif player == 2 then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
	end
	if stoneSelect == 1 then
		love.graphics.rectangle('fill', mouseMasterX - 60, mouseMasterY - 60, 120, 120)
	elseif stoneSelect == 2 then
		love.graphics.rectangle('fill', mouseMasterX - 60, mouseMasterY - 22, 120, 44)
	elseif stoneSelect == 3 then
		love.graphics.circle('fill', mouseMasterX, mouseMasterY, 50)
	end
--]]

---[[RENDERS PLAYER'S TURN
	if player == 1 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.print('It is White\'s move', 45, VIRTUAL_HEIGHT - 38)
	elseif player == 2 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.print('It is Black\'s move', 45, VIRTUAL_HEIGHT - 38)
	end
--]]

	--TITLE
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.setFont(pixelFont)
	love.graphics.print('TAK', VIRTUAL_WIDTH - 400, 40)

	--DEBUG INF0
	love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
	love.graphics.setFont(smallPixelFont)
	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. ']', VIRTUAL_WIDTH - 400, 220)
	love.graphics.print('stoneSelect: ' .. tostring(stoneSelect), VIRTUAL_WIDTH - 400, 180)

	--STONE COUNT
	love.graphics.print('player1 stones: ' .. tostring(player1stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 100)
	love.graphics.print('player2 stones: ' .. tostring(player2stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 50)
end