PlayState = Class{__includes = BaseState}

function PlayState:init()
	board = Board()
	grid = {}
	controlGrid = {}
	mouseXGrid = 0
	mouseYGrid = 0
	player = 1
	player1stones = 21
	player1capstone = 1
	player2capstone = 1
	player2stones = 21
	stoneSelect = 1
	toggleMouseStone = false
	hideMouseStone = false
	moveType = 'place'

	--POPULATES GRID TABLE WITH PROPER GRID X AND Y FILEDS AND OCCUPANT OBJECTS
	for i = 1, 5 do
		grid[i] = {}
		for j = 1, 5 do
			grid[i][j] = {}
			grid[i][j] = Occupant()
			grid[i][j].x = j * 144 - 144
			grid[i][j].y = i * 144 - 144
			for k = 1, 10 do --GIVES US MEMORY FOR 10 MEMBER OBJECTS IN EACH OCCUPANT INSTANCE
				grid[i][j].members[1] = Member(nil, nil, grid[i][j].x, grid[i][j].y)
			end
		end
	end

	--POPULATES CONTROL GRID ALL TO unassigned
	for i = 1, 5 do
		controlGrid[i] = {}
		for j = 1, 5 do
			controlGrid[i][j] = {}
			controlGrid[i][j] = 'unassigned'
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
	if mouseY < 0 or mouseY > 720 or mouseX < X_OFFSET or mouseX > 720 then --COMMENT OUT TO EASE DEBUG CRASH
		--mouseY = nil
		--mouseX = nil
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
			grid[i] = {}
			for j = 1, 5 do
				grid[i][j] = {}
				grid[i][j] = Occupant()
				grid[i][j].x = j * 144 - 144
				grid[i][j].y = i * 144 - 144
				for k = 1, 10 do --GIVES US MEMORY FOR 10 MEMBER OBJECTS IN EACH OCCUPANT INSTANCE
					grid[i][j].members[1] = Member(nil, nil, grid[i][j].x, grid[i][j].y)
				end
			end
		end
	end
--]]

---[[TOGGLE MOUSE STONE
	if love.keyboard.wasPressed('e') then
		toggleMouseStone = toggleMouseStone == false and true or false
	end
--]]

	if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
		sounds['beep']:play()
		if moveType == 'place' then
			moveType = 'move'
		elseif moveType == 'move' then
			moveType = 'place'
		end
	end

---Detect which spaces player has control over if moveType == move
	--cycle through all Occupants, check control
	--make player control spots clickable for logic
	--only render player control spots highlights
	--once clicked, top five stones move with mouse, can arrown key to move less
	--available orthogonal directions highlight red
	--initial spot renders lighter
	--arrow key to control how many stones dropped
	--drop upon click
	--lock in direction
	--highlight new appropriate directions, w/ lighter renders on past spaces
	--arrow keys to drop stone
	--click to drop

	for i = 1, 5 do
		for j = 1, 5 do
			if player == 1 then
				if grid[i][j].control == 'WHITE' then
					controlGrid[i][j] = true
				end
			elseif player == 2 then
				if grid[i][j].control == 'BLACK' then
					controlGrid[i][j] = true
				end
			end
		end
	end



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

---[[SETS SELECTION HIGHLIGHT IF UNDER MOUSE CURSOR
	for i = 1, 5 do
		for j = 1, 5 do
			if moveType == 'place' then
				if mouseXGrid == j and mouseYGrid == i then
					grid[i][j].selectionHighlight = true
				else
					grid[i][j].selectionHighlight = false
				end
			elseif moveType == 'move' then
				if player == 1 then
					if mouseXGrid == j and mouseYGrid == i then
						if grid[i][j].control == 'WHITE' then
							grid[i][j].controlHighlight = true
						end
					else
						grid[i][j].controlHighlight = false
					end
				elseif player == 2 then
					if mouseXGrid == j and mouseYGrid == i then
						if grid[i][j].control == 'BLACK' then
							grid[i][j].controlHighlight = true
						end
					else
						grid[i][j].controlHighlight = false
					end
				end
			end
		end
	end
--]]



---[[CLICK DETECTION
	function love.mousepressed(x, y, button)
		if button == 1 and mouseXGrid ~= nil and mouseYGrid ~= nil then --ENSURES WE CLICKED WITHIN GRID
			if moveType == 'place' then
				if not grid[mouseYGrid][mouseXGrid].occupied then --ENSURES STONE CANNOT BE PLACE IN OCCUPIED GRID
					sounds['stone']:play()
					if stoneSelect == 1 then --LAYSTONE PLACEMENT
						if player == 1 then
							player1stones = player1stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'WHITE' --NEED TO REMOVE 1 FROM INDEX TO SCALE IT
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'LS'
							grid[mouseYGrid][mouseXGrid].occupied = true
							grid[mouseYGrid][mouseXGrid].control = 'WHITE'
						elseif player == 2 then
							player2stones = player2stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'BLACK'
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'LS'
							grid[mouseYGrid][mouseXGrid].occupied = true
							grid[mouseYGrid][mouseXGrid].control = 'BLACK'
						end
					elseif stoneSelect == 2 then --STANDING STONE PLACEMENT
						if player == 1 then
							player1stones = player1stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'WHITE'
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'SS'
							grid[mouseYGrid][mouseXGrid].occupied = true
							grid[mouseYGrid][mouseXGrid].control = 'WHITE'
						elseif player == 2 then
							player2stones = player2stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'BLACK'
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'SS'
							grid[mouseYGrid][mouseXGrid].occupied = true
							grid[mouseYGrid][mouseXGrid].control = 'BLACK'
						end
					elseif stoneSelect == 3 then --CAPSTONE PLACEMENT
						if player == 1 then
							player1capstone = 0
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'WHITE'
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'CS'
							grid[mouseYGrid][mouseXGrid].occupied = true
							grid[mouseYGrid][mouseXGrid].control = 'WHITE' 
						elseif player == 2 then
							player2capstone = 0
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'BLACK'
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'CS'
							grid[mouseYGrid][mouseXGrid].occupied = true
							grid[mouseYGrid][mouseXGrid].control = 'BLACK'
						end
					end
					--SWAPS PLAYER AFTER SELECTION
					player = player == 1 and 2 or 1
					stoneSelect = 1
				end
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
			if moveType == 'place' then
				--RENDERS GRID HIGHLIGHT IF NOT OCCUPIED
				if grid[i][j].selectionHighlight and not grid[i][j].occupied then
					grid[i][j]:render()
				end

			elseif moveType == 'move' then
				if grid[i][j].controlHighlight then
					grid[i][j]:render()
				end
			end

			--RENDERS ONLY FIRST MEMBER STONES
			grid[i][j].members[1]:render()
		end
	end
--]]

---[[RENDERS STONE SELECTION AT MOUSE POSITION
	if not toggleMouseStone then
		if moveType == 'place' then
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
		end
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
	--love.graphics.print('stoneSelect: ' .. tostring(stoneSelect), VIRTUAL_WIDTH - 400, 180)
	if moveType == 'place' then
		love.graphics.print('moveType: place', VIRTUAL_WIDTH - 400, 180)
	elseif moveType == 'move' then
		love.graphics.print('moveType: move', VIRTUAL_WIDTH - 400, 180)
	end

	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.stoneColor: ' .. tostring(grid[mouseYGrid][mouseXGrid].members[1].stoneColor), VIRTUAL_WIDTH - 490, 220)
	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.stoneType: ' .. tostring(grid[mouseYGrid][mouseXGrid].members[1].stoneType), VIRTUAL_WIDTH - 490, 270)

	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.control: ' .. tostring(grid[mouseYGrid][mouseXGrid].control), VIRTUAL_WIDTH - 490, 320)


	--STONE COUNT
	love.graphics.print('player1 stones: ' .. tostring(player1stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 100)
	love.graphics.print('player2 stones: ' .. tostring(player2stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 50)
end