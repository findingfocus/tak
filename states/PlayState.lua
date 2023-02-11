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
	movementOriginLocked = false
	movementOriginRow = 0
	movementOriginColumn = 0
	firstMovementLocked = false
	noMovementLocked = true
	firstMovementStonesDropped = false
	bottomStoneIndex = 1
	moveType = 'place'
	moveLockedRow = 0
	moveLockedColumn = 0
	mouseStones = Occupant()
	mouseStones.members = {}
	mouseStones.members[1] = Member()

	--POPULATES GRID TABLE WITH PROPER GRID X AND Y FILEDS AND OCCUPANT OBJECTS
	for i = 1, 5 do
		grid[i] = {}
		for j = 1, 5 do --first bracket is row, second bracket is column
			grid[i][j] = {}
			grid[i][j] = Occupant()
			grid[i][j].x = j * 144 - 144
			grid[i][j].y = i * 144 - 144
			for k = 1, 10 do --GIVES US MEMORY FOR 10 MEMBER OBJECTS IN EACH OCCUPANT INSTANCE
				grid[i][j].members[k] = Member(nil, nil, grid[i][j].x, grid[i][j].y)
				mouseStones.members[k] = Member()
			end
		end
	end

---[[
	grid[1][1].members[1].stoneColor = 'WHITE'
	grid[1][1].members[1].stoneType = 'LS'
	grid[1][1].occupied = true
	grid[1][1].stackControl = 'WHITE'
	grid[1][1].members[1].stackOrder = 1

	grid[1][1].members[2].stoneColor = 'BLACK'
	grid[1][1].members[2].stoneType = 'LS'
	grid[1][1].stackControl = 'BLACK'
	grid[1][1].members[2].stackOrder = 2

	grid[1][1].members[3].stoneColor = 'WHITE'
	grid[1][1].members[3].stoneType = 'SS'
	grid[1][1].stackControl = 'WHITE'
	grid[1][1].members[3].stackOrder = 3
	grid[1][1].occupants = 3

--]]

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
					grid[i][j].members[k] = Member(nil, nil, grid[i][j].x, grid[i][j].y)
					mouseStones.members[k] = Member()
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
		if moveType == 'place' then
			sounds['beep']:play()
			moveType = 'move'
		elseif moveType == 'move' then
			if not movementOriginLocked then
				sounds['beep']:play()
				moveType = 'place'
			end
		end
	end

	if moveType == 'move' then
		for i = 1, mouseStones.occupants do
			mouseStones.members[i].x = mouseMasterX - X_OFFSET - OUTLINE - 60
			mouseStones.members[i].y = mouseMasterY - Y_OFFSET - OUTLINE - 60
		end
		--mouseStones.members[1].stoneColor = 'WHITE'
		--mouseStones.members[1].stoneType = 'LS'
	end


	--Move stone to cursor, take stone out of grid

	--Once move is complete, save current board state to undo variable. If undo is clicked, revert state and player turn

---Detect which spaces player has control over if moveType == move
	--add stack order for Members, e.g if theres two members, what color is members[2], set control
	--cycle through all Occupants, check control
	--highlight orthogonal spots that are empty or laystone
	--decide how many stones to be move
	--only render player control spots highlights
	--once clicked, top five stones move with mouse, can arrown key to move less
	--available orthogonal directions highlight red
	--initial spot renders lighter
	--arrow key to control how many stones dropped
	--drop upon click
	--lock in direction
	--highlight new appropriate directions, w/ lighter renders on past spaces
	--arrow keys to decide how manys stones to drop
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
				if mouseXGrid == j and mouseYGrid == i then --MODIFIES OCCUPANT.SELECTIONHIGHLIGHT THAT IS UNDER MOUSE LOCATION
					grid[i][j].selectionHighlight = true
				else
					grid[i][j].selectionHighlight = false
				end
			elseif moveType == 'move' then
				if player == 1 then
					if mouseXGrid == j and mouseYGrid == i and noMovementLocked then
						if grid[i][j].stackControl == 'WHITE' then
							grid[i][j].legalMove = true
							grid[i][j].legalMoveHighlight = true
						end
					elseif mouseXGrid == j and mouseYGrid == i and not noMovementLocked then
						if grid[i][j].legalMove then
							grid[i][j].legalMoveHighlight = true
						else
							grid[i][j].legalMoveHighlight = false
						end
					else
						grid[i][j].legalMoveHighlight = false
					end
				elseif player == 2 then
					if mouseXGrid == j and mouseYGrid == i  and noMovementLocked then
						if grid[i][j].stackControl == 'BLACK' then
							grid[i][j].legalMove = true
							grid[i][j].legalMoveHighlight = true
						end
					elseif mouseXGrid == j and mouseYGrid == i and not noMovementLocked then
						if grid[i][j].legalMove then
							grid[i][j].legalMoveHighlight = true
						else
							grid[i][j].legalMoveHighlight = false
						end
					else
						grid[i][j].legalMoveHighlight = false
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
					grid[mouseYGrid][mouseXGrid].occupied = true
					grid[mouseYGrid][mouseXGrid].occupants = 1
					grid[mouseYGrid][mouseXGrid].members[1].stackOrder = 1

					if stoneSelect == 1 then --LAYSTONE PLACEMENT
						grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'LS'
						if player == 1 then
							player1stones = player1stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'WHITE'
							grid[mouseYGrid][mouseXGrid].stackControl = 'WHITE'
						elseif player == 2 then
							player2stones = player2stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'BLACK'
							grid[mouseYGrid][mouseXGrid].stackControl = 'BLACK'
						end
					elseif stoneSelect == 2 then --STANDING STONE PLACEMENT
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'SS'
						if player == 1 then
							player1stones = player1stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'WHITE'
							grid[mouseYGrid][mouseXGrid].stackControl = 'WHITE'
						elseif player == 2 then
							player2stones = player2stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'BLACK'
							grid[mouseYGrid][mouseXGrid].stackControl = 'BLACK'
						end
					elseif stoneSelect == 3 then --CAPSTONE PLACEMENT
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'CS'
						if player == 1 then
							player1capstone = 0
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'WHITE'
							grid[mouseYGrid][mouseXGrid].stackControl = 'WHITE' 
						elseif player == 2 then
							player2capstone = 0
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'BLACK'
							grid[mouseYGrid][mouseXGrid].stackControl = 'BLACK'
						end
					end
					--SWAPS PLAYER AFTER SELECTION
					player = player == 1 and 2 or 1
					stoneSelect = 1
				end
			---[[
			elseif moveType == 'move' then
				if grid[mouseYGrid][mouseXGrid].legalMove and grid[mouseYGrid][mouseXGrid].occupants < 6 and not movementOriginLocked then
					movementOriginRow = mouseYGrid
					movementOriginColumn = mouseXGrid
					---[[[MOVE ALL 5 occupants to mouse positions
					for i = 1, grid[mouseYGrid][mouseXGrid].occupants do
						mouseStones.occupants = mouseStones.occupants + 1
						mouseStones.members[i].stoneColor = grid[mouseYGrid][mouseXGrid].members[i].stoneColor
						mouseStones.members[i].stoneType = grid[mouseYGrid][mouseXGrid].members[i].stoneType
						mouseStones.members[i].stackOrder = grid[mouseYGrid][mouseXGrid].members[i].stackOrder
						grid[mouseYGrid][mouseXGrid].members[i].stoneColor = nil
						grid[mouseYGrid][mouseXGrid].members[i].stoneType = nil
						grid[mouseYGrid][mouseXGrid].members[i].stackOrder = nil
					end 
					--]]
					grid[mouseYGrid][mouseXGrid].occupied = false
					noMovementLocked = false
					movementOriginLocked = true
					grid[mouseYGrid][mouseXGrid].moveLockedHighlight = true
					moveLockedRow = mouseYGrid
					moveLockedColumn = mouseXGrid
					grid[mouseYGrid][mouseXGrid].legalMoveHighlight = false
					grid[mouseYGrid][mouseXGrid].occupants = 0
				end
				--]]
			end
			
		end
	end

	if moveType == 'move' and movementOriginLocked and not firstMovementLocked then --FIRST STONES DROP

		--do some checking so we cannot drop or pickup more than we started with
		if love.keyboard.wasPressed('down') then --DROP STONE IN ORIGIN LOCKED SPACE
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants + 1].stoneColor = mouseStones.members[bottomStoneIndex].stoneColor
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants + 1].stoneType = mouseStones.members[bottomStoneIndex].stoneType
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants + 1].stackOrder = mouseStones.members[bottomStoneIndex].stackOrder
			--mouseStones.occupants = mouseStones.occupants - 1 --MAKE NEW VARIABLE TO HOLD MOUSE STONE MEMBER NUMBER
			--if mouseStones.occupants > 0 then
				grid[movementOriginRow][movementOriginColumn].occupants = grid[movementOriginRow][movementOriginColumn].occupants + 1
			--end

			grid[movementOriginRow][movementOriginColumn].occupied = true
			mouseStones.members[bottomStoneIndex].stoneColor = nil
			mouseStones.members[bottomStoneIndex].stoneType = nil
			mouseStones.members[bottomStoneIndex].stackOrder = nil
			if bottomStoneIndex == grid[movementOriginRow][movementOriginColumn].occupants then
				bottomStoneIndex = bottomStoneIndex + 1
			end



			--Add mousestones.members[bottomStone] into originLocked
			--increment the bottomstoneIndex by 1
			--Remove index 1 from mouseStones

		elseif love.keyboard.wasPressed('up') then --PICKUP STONE IN ORIGIN LOCKED SPACE
			--use occupants as top stone index?
		elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
			firstMovementStonesDropped = true
		end
	end

	--MOVE 1 LEGAL HIGHLIGHTS

	--CHANGE HIGHLIGHT BOOL TO LEGALMOVE BOOL, CONTROL HIGHLIGHT FROM THERE
	if firstMovementStonesDropped then
		if moveLockedRow == 1 and moveLockedColumn == 1 then --CORNERCASES 
			grid[1][2].legalMove = true
			grid[2][1].legalMove = true
		elseif moveLockedRow == 1 and moveLockedColumn == 5 then
			grid[1][4].legalMove = true
			grid[2][5].legalMove = true
		elseif moveLockedRow == 5 and moveLockedColumn == 1 then
			grid[4][1].legalMove = true
			grid[5][2].legalMove = true
		elseif moveLockedRow == 5 and moveLockedColumn == 5 then
			grid[5][4].legalMove = true
			grid[4][5].legalMove = true
		end
	end

	--EDGECASES
	if firstMovementStonesDropped then
		if moveLockedColumn == 1 and moveLockedRow ~= 1 and moveLockedRow ~= 5 then --LEFT EDGE
			grid[moveLockedRow - 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow + 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow][moveLockedColumn + 1].legalMove = true
		elseif moveLockedColumn == 5 and moveLockedRow ~= 1 and moveLockedRow ~= 5 then --RIGHT EDGE
			grid[moveLockedRow - 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow + 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow][moveLockedColumn - 1].legalMove = true
		elseif moveLockedRow == 1 and moveLockedColumn ~= 1 and moveLockedColumn ~= 5 then --TOP EDGE
			grid[moveLockedRow][moveLockedColumn + 1].legalMove = true
			grid[moveLockedRow][moveLockedColumn - 1].legalMove = true
			grid[moveLockedRow + 1][moveLockedColumn].legalMove = true
		elseif moveLockedRow == 5 and moveLockedColumn ~= 1 and moveLockedColumn ~= 5 then --BOTTOM EDGE
			grid[moveLockedRow][moveLockedColumn + 1].legalMove = true
			grid[moveLockedRow][moveLockedColumn - 1].legalMove = true
			grid[moveLockedRow - 1][moveLockedColumn].legalMove = true
		end
	end

	--MIDDLECASES
	if firstMovementStonesDropped then
		if moveLockedColumn > 1 and moveLockedColumn < 5 and moveLockedRow > 1 and moveLockedRow < 5 then
			grid[moveLockedRow - 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow + 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow][moveLockedColumn + 1].legalMove = true
			grid[moveLockedRow][moveLockedColumn - 1].legalMove = true
		end
	end

---[[
	for i = 1, 5 do
		for j = 1, 5 do
			if grid[i][j].members[1].stoneType == 'CS' or grid[i][j].members[1].stoneType == 'SS' then
				grid[i][j].legalMove = false
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
				if grid[i][j].legalMoveHighlight or grid[i][j].moveLockedHighlight then
					grid[i][j]:render()
				end
			end

			--RENDERS MEMBER STONES
			for i = 1, 5 do
				for j = 1, 5 do
					for k = 1, 10 do
						grid[i][j].members[k]:render()
					end
				end
			end

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
		elseif moveType == 'move' and movementOriginLocked then
			for i = 1, mouseStones.occupants do
				mouseStones.members[i]:render()
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

	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.control: ' .. tostring(grid[mouseYGrid][mouseXGrid].stackControl), VIRTUAL_WIDTH - 490, 320)
	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.occupants: ' .. tostring(grid[mouseYGrid][mouseXGrid].occupants), VIRTUAL_WIDTH - 490, 370)
	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.LM: ' .. tostring(grid[mouseYGrid][mouseXGrid].legalMove), VIRTUAL_WIDTH - 490, 420)
	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.row: ' .. tostring(moveLockedRow), VIRTUAL_WIDTH - 490, 470)
	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.column: ' .. tostring(moveLockedColumn), VIRTUAL_WIDTH - 490, 520)
	love.graphics.print('firstStonesDrop: ' .. tostring(firstMovementStonesDropped), VIRTUAL_WIDTH - 490, 570)

	--STONE COUNT
	love.graphics.print('player1 stones: ' .. tostring(player1stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 100)
	love.graphics.print('player2 stones: ' .. tostring(player2stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 50)
end