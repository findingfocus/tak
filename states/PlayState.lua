PlayState = Class{__includes = BaseState}

function PlayState:init()
	resetBoard()
end

function resetBoard()
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
	movementEvent = 0
	debugOption = 1
	lowestSurroundingOccupants = nil
	mEvent1LegalMovesPopulated = false
	toggleMouseStone = false
	hideMouseStone = false
	movementOriginLocked = false
	movementOriginRow = nil
	movementOriginColumn = nil
	firstMovementRow = nil
	firstMovementColumn = nil
	secondMovementRow = nil
	secondMovementColumn = nil
	thirdMovementRow = nil
	thirdMovementColumn = nil
	fourthMovementRow = nil
	fourthMovementColumn = nil
	downDirection = false
	upDirection = false
	leftDirection = false
	rightDirection = false
	nextMoveRow = nil
	nextMoveColumn = nil
	offGrid = false
	skipMovementEvent2 = true
	occupantIndex = nil
	capstoneCrush = false
	droppedInMovementOrigin = 0
	droppedInFirstMovement = 0
	droppedInSecondMovement = 0
	droppedInThirdMovement = 0
	stonesToCopy = 0
	lowestMSStackOrder = 1
	moveType = 'place'
	mouseStones = Occupant()
	mouseStones.members = {}
	mouseStones.occupants = 0

	--POPULATES GRID TABLE WITH PROPER GRID X AND Y FIELDS AND OCCUPANT OBJECTS
	for i = 1, 5 do
		grid[i] = {}
		for j = 1, 5 do --first bracket is row, second bracket is column
			grid[i][j] = {}
			grid[i][j] = Occupant()
			grid[i][j].x = j * 144 - 144
			grid[i][j].y = i * 144 - 144
			for k = 1, MAX_STONE_HEIGHT do --GIVES US MEMORY FOR 14 MEMBER OBJECTS IN EACH OCCUPANT INSTANCE
				grid[i][j].members[k] = Member(nil, nil, grid[i][j].x, grid[i][j].y)
				mouseStones.members[k] = Member()
			end
		end
	end
---[[
	obstaclePopulate(2, 4, 'SS', 'BLACK')
	obstaclePopulate(1, 1, 'CS', 'WHITE')
	testerPopulate(2, 1, 4)
	--testerPopulate(4, 2, 12)
	testerPopulate(4, 4, 8)
	testerPopulate(3, 4, 13)
	--testerPopulate(3, 2, 2)
	--testerPopulate(3, 5, 14)
	--testerPopulate(4, 3, 12)
--]]
end

function testerPopulate(row, column, stoneAmount)
	grid[row][column].occupied = true
	stoneColor = 1
	for i = 1, stoneAmount do
		if stoneColor == 1 then
			grid[row][column].members[i].stoneColor = 'WHITE'
		elseif stoneColor == 2 then
			grid[row][column].members[i].stoneColor = 'BLACK'
		end

		stoneColor = stoneColor == 1 and 2 or 1

		grid[row][column].members[i].stoneType = 'LS'
		grid[row][column].members[i].stackOrder = i
	end

	grid[row][column].occupants = stoneAmount
	grid[row][column].stackControl = grid[row][column].members[stoneAmount].stoneColor
	grid[row][column].stoneControl = grid[row][column].members[stoneAmount].stoneType
end

function obstaclePopulate(row, column, stoneType, stoneColor)
	grid[row][column].occupied = true
	grid[row][column].members[1].stoneType = stoneType
	grid[row][column].stoneControl = stoneType
	grid[row][column].members[1].stoneColor = stoneColor
	grid[row][column].stackControl = stoneColor
	grid[row][column].members[1].stackOrder = 1
	grid[row][column].occupants = 1
end

function updateStackControl(Occupant)
	for i = MAX_STONE_HEIGHT, 1, -1 do
		if Occupant.members[i].stoneColor ~= nil then
			Occupant.stackControl = Occupant.members[i].stoneColor
			break
		end
	end
end

function updateStoneControl(Occupant)
	for i = MAX_STONE_HEIGHT, 1, -1 do
		if Occupant.members[i].stoneType ~= nil then
			Occupant.stoneControl = Occupant.members[i].stoneType
			break
		end
	end
end

function falsifyAllOccupantsLegalMove()
	for i = 1, 5 do
		for j = 1, 5 do
			grid[i][j].legalMove = false
		end
	end
end

function clearContol(Occupant)
	Occupant.legalMoveHighlight = false
	Occupant.occupied = false
	Occupant.stoneControl = nil
	Occupant.stackControl = nil
end

function playerSwapGridReset()
	player = player == 1 and 2 or 1
	falsifyAllOccupantsLegalMove()
	grid[movementOriginRow][movementOriginColumn].legalMoveHighlight = false
	for i = 1, 5 do
		for j = 1, 5 do
			grid[i][j].moveLockedHighlight = false
		end
	end
	stoneSelect = 1
	moveType = 'place'
	movementEvent = 0
	lowestMSStackOrder = 1
	lowestSurroundingOccupants = nil
	mEvent1LegalMovesPopulated = false
	movementOriginLocked = false
	movementOriginRow = nil
	movementOriginColumn = nil
	firstMovementRow = nil
	firstMovementColumn = nil
	secondMovementRow = nil
	secondMovementColumn = nil
	thirdMovementRow = nil
	thirdMovementColumn = nil
	fourthMovementRow = nil
	fourthMovementColumn = nil
	droppedInMovementOrigin = 0
	occupantIndex = nil
	droppedInFirstMovement = 0
	droppedInSecondMovement = 0
	droppedInThirdMovement = 0
	stonesToCopy = 0
	downDirection = false
	upDirection = false
	leftDirection = false
	rightDirection = false
	nextMoveRow = nil
	nextMoveColumn = nil
	offGrid = false
	capstoneCrush = false
	skipMovementEvent2 = true
end

function dropStone(Occupant, Option)
	sounds['stone']:play()
	Occupant.occupants = Occupant.occupants + 1
	mouseStones.occupants = mouseStones.occupants - 1

	occupantIndex = Occupant.occupants
	Occupant.members[occupantIndex].stoneColor = mouseStones.members[lowestMSStackOrder].stoneColor
	Occupant.members[occupantIndex].stoneType = mouseStones.members[lowestMSStackOrder].stoneType
	Occupant.members[occupantIndex].stackOrder = occupantIndex
	Occupant.members[occupantIndex].originalStackOrder = mouseStones.members[lowestMSStackOrder].originalStackOrder

	mouseStones.members[lowestMSStackOrder].stoneColor = nil
	mouseStones.members[lowestMSStackOrder].stoneType = nil
	mouseStones.members[lowestMSStackOrder].stackOrder = nil
	mouseStones.members[lowestMSStackOrder].originalStackOrder = nil


	lowestMSStackOrder = lowestMSStackOrder + 1
	if Option == 1 then
		droppedInMovementOrigin = droppedInMovementOrigin + 1
	elseif Option == 2 then
		droppedInFirstMovement = droppedInFirstMovement + 1
	elseif Option == 3 then
		droppedInSecondMovement = droppedInSecondMovement + 1
	elseif Option == 4 then
		droppedInThirdMovement = droppedInThirdMovement + 1
	end
end

function pickUpStone(Occupant, Option)
	sounds['stone']:play()
	occupantIndex = Occupant.occupants
	Occupant.occupants = Occupant.occupants - 1
	mouseStones.occupants = mouseStones.occupants + 1

	mouseStones.members[lowestMSStackOrder - 1].stoneColor = Occupant.members[occupantIndex].stoneColor
	mouseStones.members[lowestMSStackOrder - 1].stoneType = Occupant.members[occupantIndex].stoneType
	mouseStones.members[lowestMSStackOrder - 1].stackOrder = Occupant.members[occupantIndex].originalStackOrder
	mouseStones.members[lowestMSStackOrder - 1].originalStackOrder = Occupant.members[occupantIndex].originalStackOrder

	Occupant.members[occupantIndex].stoneColor = nil
	Occupant.members[occupantIndex].stoneType = nil
	Occupant.members[occupantIndex].stackOrder = nil
	Occupant.members[occupantIndex].originalStackOrder = nil

	if Option == 1 then
		droppedInMovementOrigin = droppedInMovementOrigin - 1
	elseif Option == 2 then
		droppedInFirstMovement = droppedInFirstMovement - 1
	elseif Option == 3 then
		droppedInSecondMovement = droppedInSecondMovement - 1
	elseif Option == 4 then
		droppedInThirdMovement = droppedInThirdMovement - 1
	end

	lowestMSStackOrder = lowestMSStackOrder - 1
end

function nextMoveOffGrid(currentGridRow, currentGridColumn)
	if upDirection then
		nextMoveRow = currentGridRow - 1
		nextMoveColumn = currentGridColumn
	elseif downDirection then
		nextMoveRow = currentGridRow + 1
		nextMoveColumn = currentGridColumn
	elseif leftDirection then
		nextMoveRow = currentGridRow
		nextMoveColumn = currentGridColumn - 1
	elseif rightDirection then
		nextMoveRow = currentGridRow
		nextMoveColumn = currentGridColumn + 1
	end

	if nextMoveRow > 5 then --DETECTS WHETHER OR NOT NEXT MOVEMENT IS OFF THE GRID
		offGrid = true
	elseif nextMoveRow < 1 then
		offGrid = true
	end
	if nextMoveColumn > 5 then
		offGrid = true
	elseif nextMoveColumn < 1 then
		offGrid = true
	end
end


function nextMoveIllegal()
	if nextMoveRow >= 1 and nextMoveRow <= 5 and nextMoveColumn >= 1 and nextMoveColumn <= 5 then
		if mouseStones.occupants + grid[nextMoveRow][nextMoveColumn].occupants > 14 then
			offGrid = true
		else
			offGrid = false
		end

		if grid[nextMoveRow][nextMoveColumn].stoneControl == 'SS' or grid[nextMoveRow][nextMoveColumn].stoneControl == 'CS' then
			offGrid = true
		end
	end
end

function leftEdgeIllegalMove(i, j)
	if grid[i][j].legalMove then
		if grid[i - 1][j].stoneControl == 'SS' or grid[i - 1][j].stoneControl == 'CS' or grid[i - 1][j].occupants == 14 then
			if grid[i][j + 1].stoneControl == 'SS' or grid[i][j + 1].stoneControl == 'CS' or grid[i][j + 1].occupants == 14 then
				if grid[i + 1][j].stoneControl == 'SS' or grid[i + 1][j].stoneControl == 'CS' or grid[i + 1][j].occupants == 14 then
					grid[i][j].legalMove = false
				end
			end
		end
	end
end

function topEdgeIllegalMove(i, j)
	if grid[i][j].legalMove then
		if grid[i][j - 1].stoneControl == 'SS' or grid[i][j - 1].stoneControl == 'CS' or grid[i][j - 1].occupants == 14 then
			if grid[i + 1][j].stoneControl == 'SS' or grid[i + 1][j].stoneControl == 'CS' or grid[i + 1][j].occupants == 14 then
				if grid[i][j + 1].stoneControl == 'SS' or grid[i][j + 1].stoneControl == 'CS' or grid[i][j + 1].occupants == 14 then
					grid[i][j].legalMove = false
				end
			end
		end
	end
end

function rightEdgeIllegalMove(i, j)
	if grid[i][j].legalMove then
		if grid[i - 1][j].stoneControl == 'SS' or grid[i - 1][j].stoneControl == 'CS' or grid[i - 1][j].occupants == 14 then
			if grid[i][j - 1].stoneControl == 'SS' or grid[i][j - 1].stoneControl == 'CS' or grid[i][j - 1].occupants == 14 then
				if grid[i + 1][j].stoneControl == 'SS' or grid[i + 1][j].stoneControl == 'CS' or grid[i + 1][j].occupants == 14 then
					grid[i][j].legalMove = false
				end
			end
		end
	end
end

function bottomEdgeIllegalMove(i, j)
	if grid[i][j].legalMove then
		if grid[i][j - 1].stoneControl == 'SS' or grid[i][j - 1].stoneControl == 'CS' or grid[i][j - 1].occupants == 14 then
			if grid[i - 1][j].stoneControl == 'SS' or grid[i - 1][j].stoneControl == 'CS' or grid[i - 1][j].occupants == 14 then
				if grid[i][j + 1].stoneControl == 'SS' or grid[i][j + 1].stoneControl == 'CS' or grid[i][j + 1].occupants == 14 then
					grid[i][j].legalMove = false
				end
			end
		end
	end
end

function lowestSurroundingOccupant(originRow, originColumn)
	if originRow == 1 and originColumn == 1 then --TL
		if grid[1][2].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[1][2].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[1][2].occupants	
			end
		end
		if grid[2][1].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[2][1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[2][1].occupants	
			end
		end
	elseif originRow == 1 and originColumn == 5 then --TR
		if grid[1][4].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[1][4].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[1][4].occupants
			end
		end
		if grid[2][5].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[2][5].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[2][5].occupants
			end
		end
	elseif	originRow == 5 and originColumn == 1 then --BL
		if grid[4][1].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[4][1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[4][1].occupants
			end
		end
		if grid[5][2].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[5][2].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[5][2].occupants
			end
		end
	elseif originRow == 5 and originColumn == 5 then --BR
		if grid[4][5].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[4][5].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[4][5].occupants
			end
		end
		if grid[5][4].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[5][4].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[5][4].occupants
			end
		end
	end
	--EC
	if originRow == 1 and originColumn ~= 1 and originColumn ~= 5 then --TOP EDGE CASE --left, down, right
		if grid[originRow][originColumn - 1].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow][originColumn - 1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow][originColumn - 1].occupants
			end
		end
		if grid[originRow + 1][originColumn].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow + 1][originColumn].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow + 1][originColumn].occupants
			end
		end
		if grid[originRow][originColumn + 1].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow][originColumn + 1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow][originColumn + 1].occupants
			end
		end
	elseif originRow == 5 and originColumn ~= 1 and originColumn ~= 5 then --BOTTOM EDGE CASE --left, up, right
		if grid[originRow][originColumn - 1].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow][originColumn - 1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow][originColumn - 1].occupants
			end
		end
		if grid[originRow - 1][originColumn].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow - 1][originColumn].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow - 1][originColumn].occupants
			end
		end
		if grid[originRow][originColumn + 1].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow][originColumn + 1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow][originColumn + 1].occupants
			end
		end
	elseif originColumn == 1 and originRow ~= 1 and originRow ~= 5 then --LEFT EDGE CASE --up, right, down
		if grid[originRow - 1][originColumn].stoneControl == 'LS' then 
			if lowestSurroundingOccupants == nil or grid[originRow - 1][originColumn].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow - 1][originColumn].occupants
			end
		end
		if grid[originRow][originColumn + 1].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow][originColumn + 1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow][originColumn + 1].occupants
			end
		end
		if grid[originRow + 1][originColumn].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow + 1][originColumn].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow + 1][originColumn].occupants
			end
		end
	elseif originColumn == 5 and originRow ~= 1 and originRow ~= 5 then --RIGHT EDGE CASE --up, left, down
		if grid[originRow - 1][originColumn].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow - 1][originColumn].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow - 1][originColumn].occupants
			end
		end
		if grid[originRow][originColumn - 1].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow][originColumn - 1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow][originColumn - 1].occupants
			end
		end
		if grid[originRow + 1][originColumn].stoneControl == 'LS' then
			if lowestSurroundingOccupants == nil or grid[originRow + 1][originColumn].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow + 1][originColumn].occupants
			end
		end
	end
	--MC
	if originRow ~= 1 and originRow ~=5 and originColumn ~= 1 and originColumn ~= 5 then
		if grid[originRow - 1][originColumn].stoneControl == 'LS' then --ABOVE
			if lowestSurroundingOccupants == nil or grid[originRow - 1][originColumn].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow - 1][originColumn].occupants
			end
		end

		if grid[originRow][originColumn + 1].stoneControl == 'LS' then --TO THE RIGHT
			if lowestSurroundingOccupants == nil or grid[originRow][originColumn + 1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow][originColumn + 1].occupants
			end
		end
		if grid[originRow + 1][originColumn].stoneControl == 'LS' then --BELOW
			if lowestSurroundingOccupants == nil or grid[originRow + 1][originColumn].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow + 1][originColumn].occupants
			end
		end
		if grid[originRow][originColumn - 1].stoneControl == 'LS' then --TO THE LEFT
			if lowestSurroundingOccupants == nil or grid[originRow][originColumn - 1].occupants < lowestSurroundingOccupants then
				lowestSurroundingOccupants = grid[originRow][originColumn - 1].occupants
			end
		end
	end
end

function emptyGridSurrounding(originRow, originColumn)
	--CC
	if originRow == 1 and originColumn == 1 then
		if grid[originRow][originColumn + 1].occupants == 0 or grid[originRow + 1][originColumn].occupants == 0 then
			return true
		end
	elseif originRow == 1 and originColumn == 5 then
		if grid[originRow][originColumn - 1].occupants == 0 or grid[originRow + 1][originColumn].occupants == 0 then
			return true
		end
	elseif originRow == 5 and originColumn == 1 then
		if grid[originRow - 1][originColumn].occupants == 0 or grid[originRow][originColumn + 1].occupants == 0 then
			return true
		end
	elseif originRow == 5 and originColumn == 5 then
		if grid[originRow - 1][originColumn].occupants == 0 or grid[originRow][originColumn - 1].occupants == 0 then
			return true
		end
	end

	--EC
	if originRow == 1 and originColumn ~= 1 and originColumn ~= 5 then --TOP EDGE --left, down, right
		if grid[originRow][originColumn - 1].occupants == 0 or grid[originRow + 1][originColumn].occupants == 0 or grid[originRow][originColumn + 1].occupants == 0 then
			return true
		end
	end

	if originRow == 5 and originColumn ~= 1 and originColumn ~= 5 then --BOTTOM EDGE --left, up, right
		if grid[originRow][originColumn - 1].occupants == 0 or grid[originRow - 1][originColumn].occupants == 0 or grid[originRow][originColumn + 1].occupants == 0 then
			return true
		end
	end

	if originColumn == 1 and originRow ~= 1 and originRow ~= 5 then --LEFT EDGE --up, right, down
		if grid[originRow - 1][originColumn].occupants == 0 or grid[originRow][originColumn + 1].occupants == 0 or grid[originRow + 1][originColumn].occupants then
			return true
		end
	end

	if originColumn == 5 and originRow ~= 1 and originRow ~= 5 then --RIGHT EDGE --up, left, down
		if grid[originRow - 1][originColumn].occupants == 0 or grid[originRow][originColumn - 1].occupants == 0 or grid[originRow + 1][originColumn].occupants == 0 then 
			return true
		end
	end

	--MC
	if originRow > 1 and originRow < 5 and originColumn > 1 and originColumn < 5 then
		if grid[originRow][originColumn - 1].occupants == 0 or grid[originRow - 1][originColumn].occupants == 0 or grid[originRow][originColumn + 1].occupants == 0 or grid[originRow + 1][originColumn].occupants == 0 then
			return true
		end
	end

	return false
end

function CSCrush(originRow, originColumn)
	if mouseStones.occupants == 1 and mouseStones.stoneControl == 'CS' then
		--CC
		if originRow == 1 and originColumn == 1 then
			if grid[1][2].stoneControl == 'SS' then
				grid[1][2].legalMove = true
			end

			if grid[2][1].stoneControl == 'SS' then
				grid[2][1].legalMove = true
			end
		elseif originRow == 1 and originColumn == 5 then 
			if grid[1][4].stoneControl == 'SS' then
				grid[1][4].legalMove = true
			end

			if grid[2][5].stoneControl == 'SS' then
				grid[2][5].legalMove = true
			end
		elseif originRow == 5 and originColumn == 1 then
			if grid[4][1].stoneControl == 'SS' then
				grid[4][1].legalMove = true
			end

			if grid[5][2].stoneControl == 'SS' then
				grid[5][2].legalMove = true
			end
		elseif originRow == 5 and originColumn == 5 then
			if grid[4][5].stoneControl == 'SS' then
				grid[4][5].legalMove = true
			end

			if grid[5][4].stoneControl == 'SS' then
				grid[5][4].legalMove = true
			end
		end
		--EC
		--TOPEDGE -L,D,R
		if originRow == 1 and originColumn ~= 1 and originColumn ~= 5 then
			if grid[originRow][originColumn - 1].stoneControl == 'SS' then
				grid[originRow][originColumn - 1].legalMove = true
			end

			if grid[originRow + 1][originColumn].stoneControl == 'SS' then
				grid[originRow + 1][originColumn].legalMove = true
			end

			if grid[originRow][originColumn + 1].stoneControl == 'SS' then
				grid[originRow][originColumn + 1].legalMove = true
			end
		end

		--RIGHT EDGE -U,L,D
		if originColumn == 5 and originRow ~= 1 and originRow ~= 5 then
			if grid[originRow - 1][originColumn].stoneControl == 'SS' then
				grid[originRow - 1][originColumn].legalMove = true
			end

			if grid[originRow][originColumn - 1].stoneControl == 'SS' then
				grid[originRow][originColumn - 1].legalMove = true
			end

			if grid[originRow + 1][originColumn].stoneControl == 'SS' then
				grid[originRow + 1][originColumn].legalMove = true
			end
		end

		--BOTTOMEDGE -L,U,R
		if originRow == 5 and originColumn ~= 1 and originColumn ~= 5 then
			if grid[originRow][originColumn - 1].stoneControl == 'SS' then
				grid[originRow][originColumn - 1].legalMove = true
			end

			if grid[originRow - 1][originColumn].stoneControl == 'SS' then
				grid[originRow - 1][originColumn].legalMove = true
			end

			if grid[originRow][originColumn + 1].stoneControl == 'SS' then
				grid[originRow][originColumn + 1].legalMove = true
			end
		end

		--LEFTEDGE -U,R,D
		if originColumn == 1 and originRow ~= 1 and originRow ~= 5 then
			if grid[originRow - 1][originColumn].stoneControl == 'SS' then
				grid[originRow - 1][originColumn].legalMove = true
			end

			if grid[originRow][originColumn + 1].stoneControl == 'SS' then
				grid[originRow][originColumn + 1].legalMove = true
			end

			if grid[originRow + 1][originColumn].stoneControl == 'SS' then
				grid[originRow + 1][originColumn].legalMove = true
			end
		end

		--MIDDLECASE
		if originRow ~= 1 and originRow ~= 5 and originColumn ~= 1 and originColumn ~= 5 then
			if grid[originRow - 1][originColumn].stoneControl == 'SS' then
				grid[originRow - 1][originColumn].legalMove = true
			end

			if grid[originRow][originColumn + 1].stoneControl == 'SS' then
				grid[originRow][originColumn + 1].legalMove = true
			end

			if grid[originRow + 1][originColumn].stoneControl == 'SS' then
				grid[originRow + 1][originColumn].legalMove = true
			end

			if grid[originRow][originColumn - 1].stoneControl == 'SS' then
				grid[originRow][originColumn - 1].legalMove = true
			end
		end
	end
end

function PlayState:update(dt)
---[[DEBUG OPTIONS
	if love.keyboard.isDown('2') then
		debugOption = 2
	elseif love.keyboard.isDown('3') then
		debugOption = 3
	else
		debugOption = 1
	end
--]]

---[[MOUSE POSITION VARIABLES
	mouseMasterX, mouseMasterY = love.mouse.getPosition()
	mouseX, mouseY = love.mouse.getPosition()
	--SHIFTS MOUSE_X AND MOUSE_Y TO GRID COORDINATES RATHER THAN SCREEN COORDINATES
	mouseY = mouseY - Y_OFFSET
	mouseX = mouseX - X_OFFSET

	--[NILLIFY THE MOUSE COORDINATES IF OFF GRID
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
		resetBoard()
	end
--]]

---[[TOGGLE MOUSE STONE
	if love.keyboard.wasPressed('e') then
		toggleMouseStone = toggleMouseStone == false and true or false
	end
--]]


---[[STONE SELECT
	if moveType == 'place' then
	
		--mouseStones.occupants = 1

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

	for i = 1, 5 do
		for j = 1, 5 do --UPDATES OCCUPANTS LEGALMOVE HIGHLIGHT BASED ON LEGAL MOVE STATUS
			grid[i][j]:update(dt)
		end
	end
--]]

---[[SWAP MOVETYPES
	if moveType == 'place' then

		movementEvent = 0

		if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
			sounds['beep']:play()
			moveType = 'move'
		end
		if player == 1 and player1stones < 1 then
			moveType = 'move'
		end
		if player == 2 and player2stones < 1 then
			moveType = 'move'
		end
	elseif moveType == 'move'  and movementEvent == 1 then
		if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
			if player == 1 and player1stones > 0 then
				sounds['beep']:play()
				moveType = 'place'
			end
			if player == 2 and player2stones > 0 then
				sounds['beep']:play()
				moveType = 'place'
			end
		end
	end
--]]

---[PLACING A STONE IN EMPTY SPOT
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
					updateStoneControl(grid[mouseYGrid][mouseXGrid])
					falsifyAllOccupantsLegalMove()
					mEvent1LegalMovesPopulated = false
				end
			end
		end
	end
--]]

	if moveType == 'move' then
		if movementEvent == 0 then
			movementEvent = 1
		end

		for i = 1, MAX_STONE_HEIGHT do --MOUSE STONES POSITION UPDATES
			mouseStones.members[i].x = mouseMasterX - X_OFFSET - OUTLINE - 60
			mouseStones.members[i].y = mouseMasterY - Y_OFFSET - OUTLINE - 60
		end
		
		if movementEvent == 1 then --LEGAL MOVE HIGHLIGHTS
			if mEvent1LegalMovesPopulated == false then
				for i = 1, 5 do
					for j = 1, 5 do
						if player == 1 then --SET LEGAL MOVES UPON STACKCONTROL
							if grid[i][j].stackControl == 'WHITE' then
								grid[i][j].legalMove = true
						end
						elseif player == 2 then --SET LEGAL MOVES UPON STACKCONTROL
							if grid[i][j].stackControl == 'BLACK' then
								grid[i][j].legalMove = true
							end
						end

						--CORNERCASES 
						if i == 1 and j == 1 then
							if grid[1][2].stoneControl == 'SS' or grid[1][2].stoneControl == 'CS' or grid[1][2].occupants == 14--[[(math.min(grid[1][1].occupants, 5) + grid[1][2].occupants) > 14]] then
								if grid[2][1].stoneControl == 'SS' or grid[2][1].stoneControl == 'CS' or grid[2][1].occupants == 14 then
									grid[1][1].legalMove = false
								end
							end
						end

						if i == 1 and j == 5 then
							if grid[1][4].stoneControl == 'SS' or grid[1][4].stoneControl == 'CS' or grid[1][4].occupants == 14 then
								if grid[2][5].stoneControl == 'SS' or grid[2][5].stoneControl == 'CS' or grid[2][5].occupants == 14 then
									grid[1][5].legalMove = false
								end
							end
						end

						if i == 5 and j == 1 then
							if grid[4][1].stoneControl == 'SS' or grid[4][1].stoneControl == 'CS' or grid[4][1].occupants == 14 then
								if grid[5][2].stoneControl == 'SS' or grid[5][2].stoneControl == 'CS' or grid[5][2].occupants == 14 then
									grid[5][1].legalMove = false
								end
							end
						end

						if i == 5 and j == 5 then
							if grid[4][5].stoneControl == 'SS' or grid[4][5].stoneControl == 'CS' or grid[4][5].occupants == 14 then
								if grid[5][4].stoneControl == 'SS' or grid[5][4].stoneControl == 'CS' or grid[5][4].occupants == 14 then
									grid[5][5].legalMove = false
								end
							end
						end

						--EDGECASES
						if j == 1 and i ~= 1 and i ~= 5 then --LEFTEDGE
							if i == 2 then
								leftEdgeIllegalMove(i, j)
							elseif i == 3 then
								leftEdgeIllegalMove(i, j)
							elseif i == 4 then
								leftEdgeIllegalMove(i, j)
							end
						end

						if i == 1 and j ~= 1 and j ~= 5 then --TOPEDGE
							if j == 2 then 
								topEdgeIllegalMove(i, j)
							elseif j == 3 then
								topEdgeIllegalMove(i, j)
							elseif j == 4 then
								topEdgeIllegalMove(i, j)
							end
						end

						if j == 5 and i ~= 1 and i ~= 5 then --RIGHTEDGE
							if i == 2 then
								rightEdgeIllegalMove(i, j)
							elseif i == 3 then
								rightEdgeIllegalMove(i, j)
							elseif i == 4 then
								rightEdgeIllegalMove(i, j)
							end
						end

						if i == 5 and j ~= 1 and j ~= 5 then --BOTTOMEDGE
							if j == 2 then
								bottomEdgeIllegalMove(i, j)
							elseif j == 3 then
								bottomEdgeIllegalMove(i, j)
							elseif j == 4 then
								bottomEdgeIllegalMove(i, j)
							end
						end

						if i ~= 1 and i ~= 5 and j ~= 1 and j ~= 5 then --IF GRID IS COMPLETELY SURROUNDED BY ILLEGAL MOVES, THEN WE ARE AN ILLEGAL MOVE
							if grid[i][j].legalMove then
								if grid[i - 1][j].stoneControl == 'SS' or grid[i - 1][j].stoneControl == 'CS' or grid[i - 1][j].occupants == 14 then--(math.min(grid[i][j].occupants, 5) + grid[i - 1][j].occupants > 14) then --TOP
									if grid[i + 1][j].stoneControl == 'SS' or grid[i + 1][j].stoneControl == 'CS' or grid[i + 1][j].occupants == 14 then --(math.min(grid[i][j].occupants, 5) + grid[i + 1][j].occupants > 14) then --BOTTOM
										if grid[i][j - 1].stoneControl == 'SS' or grid[i][j - 1].stoneControl == 'CS' or grid[i][j - 1].occupants == 14 then --(math.min(grid[i][j].occupants, 5) + grid[i][j - 1].occupants > 14) then --LEFT
											if grid[i][j + 1].stoneControl == 'SS' or grid[i][j + 1].stoneControl == 'CS' or grid[i][j + 1].occupants == 14 then --(math.min(grid[i][j].occupants, 5) + grid[i][j + 1].occupants > 14) then --RIGHT
												grid[i][j].legalMove = false
											end
										end
									end
								end
							end
						end

						for i = 1, 5 do --ENABLES CS TO BE LEGAL MOVE EVEN IF SURROUNDED BY SS
							for j = 1, 5 do
								if player == 1 and grid[i][j].stackControl == 'WHITE' then
									if grid[i][j].stoneControl == 'CS' then
										grid[i][j].legalMove = true
									end
								elseif player == 2 and grid[i][j].stackControl == 'BLACK' then
									if grid[i][j].stoneControl == 'CS' then
										grid[i][j].legalMove = true
									end
								end
							end
						end
					end
				end
				mEvent1LegalMovesPopulated = true
			end

			--RENDER LEGALMOVEHIGHLIGHTS UPON MOUSEOVER
			for i = 1, 5 do
				for j = 1, 5 do
					if mouseYGrid == i and mouseXGrid == j and grid[mouseYGrid][mouseXGrid].legalMove then
						grid[i][j].legalMoveHighlight = true
					else
						grid[i][j].legalMoveHighlight = false
					end
				end
			end

		
	
			function love.mousepressed(x, y, button) --LOCK IN MOVEMENT ORIGIN GRID
				if button == 1 then
					if grid[mouseYGrid][mouseXGrid].legalMove then
						--grid[mouseYGrid][mouseXGrid].legalMove = false
						movementOriginRow = mouseYGrid
						movementOriginColumn = mouseXGrid
						lowestSurroundingOccupant(movementOriginRow, movementOriginColumn)

						if grid[mouseYGrid][mouseXGrid].occupants >= 5 then
							stonesToCopy = 5
						else
							stonesToCopy = grid[mouseYGrid][mouseXGrid].occupants
						end

						for i = 1, stonesToCopy do
							if i == stonesToCopy then
								lowestMSStackOrder = grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stackOrder
							end
							mouseStones.members[grid[mouseYGrid][mouseXGrid].occupants].stoneColor = grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stoneColor
							mouseStones.members[grid[mouseYGrid][mouseXGrid].occupants].stoneType = grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stoneType
							mouseStones.members[grid[mouseYGrid][mouseXGrid].occupants].stackOrder = grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stackOrder
							mouseStones.members[grid[mouseYGrid][mouseXGrid].occupants].originalStackOrder = grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stackOrder
							mouseStones.stoneControl = grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stoneType
							grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stoneColor = nil
							grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stoneType = nil
							grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stackOrder = nil

							mouseStones.occupants = mouseStones.occupants + 1
							grid[mouseYGrid][mouseXGrid].occupants = grid[mouseYGrid][mouseXGrid].occupants - 1
						end

						updateStoneControl(mouseStones)
						updateStoneControl(grid[mouseYGrid][mouseXGrid])
						updateStackControl(grid[mouseYGrid][mouseXGrid])

						falsifyAllOccupantsLegalMove() --FALSIFY ALL LEGAL MOVES ONCE MOVEMENTORIGIN LOCKED
						
						--CORNERCASES 
						if movementOriginRow == 1 and movementOriginColumn == 1 then
							grid[1][2].legalMove = true
							grid[2][1].legalMove = true
						elseif movementOriginRow == 1 and movementOriginColumn == 5 then
							grid[1][4].legalMove = true
							grid[2][5].legalMove = true
						elseif movementOriginRow == 5 and movementOriginColumn == 1 then
							grid[4][1].legalMove = true
							grid[5][2].legalMove = true
						elseif movementOriginRow == 5 and movementOriginColumn == 5 then
							grid[5][4].legalMove = true
							grid[4][5].legalMove = true
						end

						--EDGECASES
						if movementOriginColumn == 1 and movementOriginRow ~= 1 and movementOriginRow ~= 5 then --LEFT EDGE
							grid[movementOriginRow - 1][movementOriginColumn].legalMove = true
							grid[movementOriginRow + 1][movementOriginColumn].legalMove = true
							grid[movementOriginRow][movementOriginColumn + 1].legalMove = true
						elseif movementOriginColumn == 5 and movementOriginRow ~= 1 and movementOriginRow ~= 5 then --RIGHT EDGE
							grid[movementOriginRow - 1][movementOriginColumn].legalMove = true
							grid[movementOriginRow + 1][movementOriginColumn].legalMove = true
							grid[movementOriginRow][movementOriginColumn - 1].legalMove = true
						elseif movementOriginRow == 1 and movementOriginColumn ~= 1 and movementOriginColumn ~= 5 then --TOP EDGE
							grid[movementOriginRow][movementOriginColumn + 1].legalMove = true
							grid[movementOriginRow][movementOriginColumn - 1].legalMove = true
							grid[movementOriginRow + 1][movementOriginColumn].legalMove = true
						elseif movementOriginRow == 5 and movementOriginColumn ~= 1 and movementOriginColumn ~= 5 then --BOTTOM EDGE
							grid[movementOriginRow][movementOriginColumn + 1].legalMove = true
							grid[movementOriginRow][movementOriginColumn - 1].legalMove = true
							grid[movementOriginRow - 1][movementOriginColumn].legalMove = true
						end


						--MIDDLECASES
						if movementOriginColumn > 1 and movementOriginColumn < 5 and movementOriginRow > 1 and movementOriginRow < 5 then
							grid[movementOriginRow - 1][movementOriginColumn].legalMove = true
							grid[movementOriginRow + 1][movementOriginColumn].legalMove = true
							grid[movementOriginRow][movementOriginColumn + 1].legalMove = true
							grid[movementOriginRow][movementOriginColumn - 1].legalMove = true
						end

						for i = 1, 5 do
							for j = 1, 5 do
								if grid[i][j].stoneControl == 'CS' or grid[i][j].stoneControl == 'SS' then --MAKES MOVEMENT ON A CAPSTONE OR SS IMPOSSIBLE
									grid[i][j].legalMove = false
								end
							end
						end

						for i = 1, MAX_STONE_HEIGHT do --FIX THIS FOR PICKING UP MORE THAN 5
							if mouseStones.members[i].stackOrder ~= nil then
								--lowestMSStackOrder = mouseStones.members[i].stackOrder
							end
						end

						movementEvent = 2
					end
				end
			end

		elseif movementEvent == 2 then --LOCKS STONES IN HAND FOR FIRST MOVEMENT
			if mouseStones.occupants == 1 and skipMovementEvent2 then
				updateStoneControl(grid[movementOriginRow][movementOriginColumn])
				updateStackControl(grid[movementOriginRow][movementOriginColumn])
				CSCrush(movementOriginRow, movementOriginColumn)
				movementEvent = 3
			else
				skipMovementEvent2 = false
			end
			if love.keyboard.wasPressed('down') and mouseStones.occupants > 1 then --DROP STONE IN MOVEMENT ORIGIN
				dropStone(grid[movementOriginRow][movementOriginColumn], 1) --Second Argument is grid occupant to drop stones into
			elseif love.keyboard.wasPressed('up') and droppedInMovementOrigin > 0 then
				pickUpStone(grid[movementOriginRow][movementOriginColumn], 1)
			elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
				CSCrush(movementOriginRow, movementOriginColumn)
				if emptyGridSurrounding(movementOriginRow, movementOriginColumn) then
					for i = 1 , 5 do
						for j = 1, 5 do
							if grid[i][j].legalMove then
								if mouseStones.occupants + grid[i][j].occupants > 14 then
									grid[i][j].legalMove = false
								end
							end
						end
					end
					updateStoneControl(grid[movementOriginRow][movementOriginColumn])
					updateStackControl(grid[movementOriginRow][movementOriginColumn])
					movementEvent = 3
				elseif mouseStones.occupants + lowestSurroundingOccupants <= 14 then
					for i = 1 , 5 do
						for j = 1, 5 do
							if grid[i][j].legalMove then
								if mouseStones.occupants + grid[i][j].occupants > 14 then
									grid[i][j].legalMove = false
								end
							end
						end
					end
					updateStoneControl(grid[movementOriginRow][movementOriginColumn])
					updateStackControl(grid[movementOriginRow][movementOriginColumn])
					movementEvent = 3
				end
			end

		elseif movementEvent == 3 then --SELECT FM GRID
			
			for i = 1, 5 do
				for j = 1, 5 do
					if mouseYGrid == i and mouseXGrid == j then --LEGALMOVE HIGHLIGHTS UPON MOUSEOVER
						if grid[i][j].legalMove then
							grid[i][j].moveLockedHighlight = true
						end
					else
						grid[i][j].moveLockedHighlight = false
					end

					if grid[i][j].occupants == 14 then
						grid[i][j].legalMove = false
					end
				end
			end

			function love.mousepressed(x, y, button) --SELECTING FM GRID
				if button == 1 then
					for i = 1, 5 do
						for j = 1, 5 do
							if mouseYGrid == i and mouseXGrid == j then
								if grid[i][j].legalMove then
									grid[i][j].legalMoveHighlight = false
									grid[i][j].moveLockedHighlight = true
									grid[i][j].legalMove = false
									firstMovementRow = i
									firstMovementColumn = j

									if movementOriginRow < firstMovementRow then
										downDirection = true
									elseif movementOriginRow > firstMovementRow then
										upDirection = true
									elseif movementOriginColumn < firstMovementColumn then
										rightDirection = true
									elseif movementOriginColumn > firstMovementColumn then
										leftDirection = true
									end
									falsifyAllOccupantsLegalMove()
									nextMoveOffGrid(firstMovementRow, firstMovementColumn)
									if not offGrid then
										nextMoveIllegal()
									end
									--IF NEXTGRID .STONECONTROL == 'CS' or 'SS' THEN offGRID = True

									movementEvent = 4
								end
							end
						end
					end
				end
			end

		elseif movementEvent == 4 then --LOCKS IN STONES IN HAND FOR OUR SECOND MOVEMENT
			if love.keyboard.wasPressed('down') and mouseStones.occupants > 0 then
				if mouseStones.occupants == 1 and mouseStones.stoneControl == 'CS' and grid[firstMovementRow][firstMovementColumn].stoneControl == 'SS' then
					capstoneCrush = true
					grid[firstMovementRow][firstMovementColumn].members[grid[firstMovementRow][firstMovementColumn].occupants].stoneType = 'LS'
					updateStoneControl(grid[firstMovementRow][firstMovementColumn])
					sounds['crush']:setVolume(.6)
					sounds['crush']:play()
				end
				dropStone(grid[firstMovementRow][firstMovementColumn], 2)
				updateStoneControl(grid[firstMovementRow][firstMovementColumn])
				nextMoveIllegal()
			end

			if love.keyboard.wasPressed('up') and droppedInFirstMovement > 0 and not capstoneCrush then
				pickUpStone(grid[firstMovementRow][firstMovementColumn], 2)
				nextMoveIllegal()
			end

			if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
				if mouseStones.occupants == 0 then --OFFGRID ENDING TURN
					updateStoneControl(grid[firstMovementRow][firstMovementColumn])
					updateStackControl(grid[firstMovementRow][firstMovementColumn])
					grid[firstMovementRow][firstMovementColumn].occupied = true
					if grid[movementOriginRow][movementOriginColumn].occupants == 0 then
						if grid[movementOriginRow][movementOriginColumn].occupants == 0 then
							grid[movementOriginRow][movementOriginColumn].legalMoveHighlight = false
							grid[movementOriginRow][movementOriginColumn].occupied = false
							clearContol(grid[movementOriginRow][movementOriginColumn])
						end
					end
					playerSwapGridReset()
				elseif offGrid then --CS CRUSH
					if mouseStones.occupants == 1 and mouseStones.stoneControl == 'CS' then
						offGrid = false
						updateStoneControl(grid[firstMovementRow][firstMovementColumn])
						updateStackControl(grid[firstMovementRow][firstMovementColumn])
						grid[firstMovementRow][firstMovementColumn].occupied = true

						if upDirection then
							secondMovementRow = firstMovementRow - 1
							secondMovementColumn = firstMovementColumn 			
						elseif downDirection then
							secondMovementRow = firstMovementRow + 1
							secondMovementColumn = firstMovementColumn
						elseif leftDirection then
							secondMovementRow = firstMovementRow
							secondMovementColumn = firstMovementColumn - 1
						elseif rightDirection then
							secondMovementRow = firstMovementRow
							secondMovementColumn = firstMovementColumn + 1
						end

						if grid[movementOriginRow][movementOriginColumn].occupants == 0 then
							clearContol(grid[movementOriginRow][movementOriginColumn])
						end

						nextMoveOffGrid(secondMovementRow, secondMovementColumn)
						
						if not offGrid then
							nextMoveIllegal()
						end
						
						movementEvent = 5
					end
				elseif not offGrid and droppedInFirstMovement > 0 then --ENTER PRESSED AFTER DROPPING SOME STONES
					updateStoneControl(grid[firstMovementRow][firstMovementColumn])
					updateStackControl(grid[firstMovementRow][firstMovementColumn])
					grid[firstMovementRow][firstMovementColumn].occupied = true

					if upDirection then
						secondMovementRow = firstMovementRow - 1
						secondMovementColumn = firstMovementColumn 			
					elseif downDirection then
						secondMovementRow = firstMovementRow + 1
						secondMovementColumn = firstMovementColumn
					elseif leftDirection then
						secondMovementRow = firstMovementRow
						secondMovementColumn = firstMovementColumn - 1
					elseif rightDirection then
						secondMovementRow = firstMovementRow
						secondMovementColumn = firstMovementColumn + 1
					end

					if grid[movementOriginRow][movementOriginColumn].occupants == 0 then
						clearContol(grid[movementOriginRow][movementOriginColumn])
					end

					nextMoveOffGrid(secondMovementRow, secondMovementColumn)
					nextMoveIllegal()
					movementEvent = 5
				end
			end

		elseif movementEvent == 5 then
			grid[secondMovementRow][secondMovementColumn].moveLockedHighlight = true
			if love.keyboard.wasPressed('down') and mouseStones.occupants > 0 then
				if mouseStones.occupants == 1 and mouseStones.stoneControl == 'CS' and grid[secondMovementRow][secondMovementColumn].stoneControl == 'SS' then
					capstoneCrush = true
					grid[secondMovementRow][secondMovementColumn].members[grid[secondMovementRow][secondMovementColumn].occupants].stoneType = 'LS'
					updateStoneControl(grid[secondMovementRow][secondMovementColumn])
					sounds['crush']:setVolume(.6)
					sounds['crush']:play()
				end
				dropStone(grid[secondMovementRow][secondMovementColumn], 3)
				updateStoneControl(grid[secondMovementRow][secondMovementColumn])
				nextMoveIllegal()
			end

			if love.keyboard.wasPressed('up') and droppedInSecondMovement > 0 and not capstoneCrush then
				pickUpStone(grid[secondMovementRow][secondMovementColumn], 3)
				nextMoveIllegal()
			end

			if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
				if mouseStones.occupants == 0 then --OFFGRID ENDING TURN
					updateStoneControl(grid[secondMovementRow][secondMovementColumn])
					updateStackControl(grid[secondMovementRow][secondMovementColumn])
					grid[firstMovementRow][firstMovementColumn].occupied = true
	
					playerSwapGridReset()
				elseif offGrid then
					if mouseStones.occupants == 1 and mouseStones.stoneControl == 'CS' then
						offGrid = false
						updateStoneControl(grid[secondMovementRow][secondMovementColumn])
						updateStackControl(grid[secondMovementRow][secondMovementColumn])
						grid[secondMovementRow][secondMovementColumn].occupied = true

						if upDirection then
							thirdMovementRow = secondMovementRow - 1
							thirdMovementColumn = secondMovementColumn 			
						elseif downDirection then
							thirdMovementRow = secondMovementRow + 1
							thirdMovementColumn = secondMovementColumn
						elseif leftDirection then
							thirdMovementRow = secondMovementRow
							thirdMovementColumn = secondMovementColumn - 1
						elseif rightDirection then
							thirdMovementRow = secondMovementRow
							thirdMovementColumn = secondMovementColumn + 1
						end

						nextMoveOffGrid(thirdMovementRow, thirdMovementColumn)
						nextMoveIllegal()
						movementEvent = 6
					end
				elseif not offGrid and droppedInSecondMovement > 0 then --ENTER PRESSED AFTER DROPPING SOME STONES
					updateStoneControl(grid[secondMovementRow][secondMovementColumn])
					updateStackControl(grid[secondMovementRow][secondMovementColumn])
					grid[secondMovementRow][secondMovementColumn].occupied = true

					if upDirection then
						thirdMovementRow = secondMovementRow - 1
						thirdMovementColumn = secondMovementColumn 			
					elseif downDirection then
						thirdMovementRow = secondMovementRow + 1
						thirdMovementColumn = secondMovementColumn
					elseif leftDirection then
						thirdMovementRow = secondMovementRow
						thirdMovementColumn = secondMovementColumn - 1
					elseif rightDirection then
						thirdMovementRow = secondMovementRow
						thirdMovementColumn = secondMovementColumn + 1
					end

					nextMoveOffGrid(thirdMovementRow, thirdMovementColumn)
					nextMoveIllegal()
					movementEvent = 6
				end
			end

		elseif movementEvent == 6 then
			grid[thirdMovementRow][thirdMovementColumn].moveLockedHighlight = true

			if love.keyboard.wasPressed('down') and mouseStones.occupants > 0 then
				if mouseStones.occupants == 1 and mouseStones.stoneControl == 'CS' and grid[thirdMovementRow][thirdMovementColumn].stoneControl == 'SS' then
					capstoneCrush = true
					grid[thirdMovementRow][thirdMovementColumn].members[grid[thirdMovementRow][thirdMovementColumn].occupants].stoneType = 'LS'
					updateStoneControl(grid[thirdMovementRow][thirdMovementColumn])
					sounds['crush']:setVolume(.6)
					sounds['crush']:play()
				end
				dropStone(grid[thirdMovementRow][thirdMovementColumn], 4)
				updateStoneControl(grid[thirdMovementRow][thirdMovementColumn])
				nextMoveIllegal()
			end

			if love.keyboard.wasPressed('up') and droppedInThirdMovement > 0 and not capstoneCrush then
				pickUpStone(grid[thirdMovementRow][thirdMovementColumn], 4)
				nextMoveIllegal()
			end

			if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
				if mouseStones.occupants == 0 then --OFFGRID ENDING TURN
						updateStoneControl(grid[thirdMovementRow][thirdMovementColumn])
						updateStackControl(grid[thirdMovementRow][thirdMovementColumn])
						grid[thirdMovementRow][thirdMovementColumn].occupied = true
		
						playerSwapGridReset()
				elseif offGrid then
					if mouseStones.occupants == 1 and mouseStones.stoneControl == 'CS' then
						offGrid = false
						updateStoneControl(grid[thirdMovementRow][thirdMovementColumn])
						updateStackControl(grid[thirdMovementRow][thirdMovementColumn])
						grid[thirdMovementRow][thirdMovementColumn].occupied = true

						if upDirection then
							fourthMovementRow = thirdMovementRow - 1
							fourthMovementColumn = thirdMovementColumn 			
						elseif downDirection then
							fourthMovementRow = thirdMovementRow + 1
							fourthMovementColumn = thirdMovementColumn
						elseif leftDirection then
							fourthMovementRow = thirdMovementRow
							fourthMovementColumn = thirdMovementColumn - 1
						elseif rightDirection then
							fourthMovementRow = thirdMovementRow
							fourthMovementColumn = thirdMovementColumn + 1
						end

						nextMoveOffGrid(thirdMovementRow, thirdMovementColumn)
						--nextMoveIllegal()
						movementEvent = 7
					end
				elseif not offGrid and droppedInThirdMovement > 0 then --ENTER PRESSED AFTER DROPPING SOME STONES
					updateStoneControl(grid[thirdMovementRow][thirdMovementColumn])
					updateStackControl(grid[thirdMovementRow][thirdMovementColumn])
					grid[thirdMovementRow][thirdMovementColumn].occupied = true

					if upDirection then
						fourthMovementRow = thirdMovementRow - 1
						fourthMovementColumn = thirdMovementColumn 			
					elseif downDirection then
						fourthMovementRow = thirdMovementRow + 1
						fourthMovementColumn = thirdMovementColumn
					elseif leftDirection then
						fourthMovementRow = thirdMovementRow
						fourthMovementColumn = thirdMovementColumn - 1
					elseif rightDirection then
						fourthMovementRow = thirdMovementRow
						fourthMovementColumn = thirdMovementColumn + 1
					end

					nextMoveOffGrid(fourthMovementRow, fourthMovementColumn)
					--nextMoveIllegal()
					movementEvent = 7
				end
			end

		elseif movementEvent == 7 then
			grid[fourthMovementRow][fourthMovementColumn].moveLockedHighlight = true
			if love.keyboard.wasPressed('down') and mouseStones.occupants > 0 then
				if mouseStones.occupants == 1 and mouseStones.stoneControl == 'CS' and grid[fourthMovementRow][fourthMovementColumn].stoneControl == 'SS' then
					capstoneCrush = true
					grid[fourthMovementRow][fourthMovementColumn].members[grid[fourthMovementRow][fourthMovementColumn].occupants].stoneType = 'LS'
					updateStoneControl(grid[fourthMovementRow][fourthMovementColumn])
					sounds['crush']:setVolume(.6)
					sounds['crush']:play()
				end
				dropStone(grid[fourthMovementRow][fourthMovementColumn], nil)
				updateStoneControl(grid[fourthMovementRow][fourthMovementColumn])
			end

			if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
				if mouseStones.occupants == 0 then
					playerSwapGridReset()
				end
			end
		end

	end
	--]]


---[[MOVEMENT ORIGIN HIGHLIGHT
	if movementOriginRow ~= nil and movementOriginColumn ~= nil then
		grid[movementOriginRow][movementOriginColumn].legalMoveHighlight = true
	end
	
--]]
---[[LEGAL MOVES HIGHLIGHTS
	for i = 1, 5 do
		for j = 1, 5 do
			if moveType == 'place' then
				if mouseXGrid == j and mouseYGrid == i and grid[mouseYGrid][mouseXGrid].occupants == 0 then --SELECTIONHIGHLIGHT IF OVER MOUSE LOCATION
					grid[i][j].selectionHighlight = true
				else
					grid[i][j].selectionHighlight = false
				end
			end
		end
	end
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
					for k = 1, MAX_STONE_HEIGHT do
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
			if player == 1 and player1stones > 0 then --ask about player stones to fix 1 frame render bug
				love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
			elseif player == 2 and player2stones > 0 then
				love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
			else
				love.graphics.setColor(0/255, 0/255, 0/255, 0/255) --to fix one frame render bug
			end
			if stoneSelect == 1 then
				love.graphics.rectangle('fill', mouseMasterX - 60, mouseMasterY - 60, 120, 120)
			elseif stoneSelect == 2 then
				love.graphics.rectangle('fill', mouseMasterX - 60, mouseMasterY - 22, 120, 44)
			elseif stoneSelect == 3 then
				love.graphics.circle('fill', mouseMasterX, mouseMasterY, 50)
			end
		elseif moveType == 'move' and movementEvent > 1 then
			for i = 1, MAX_STONE_HEIGHT do
				mouseStones.members[i]:render()
			end
		end
	end
--]]

---[[RENDERS PLAYER'S TURN
	love.graphics.setFont(smallFont)
	if player == 1 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.print('It is White\'s move', 45, VIRTUAL_HEIGHT - 38)
	elseif player == 2 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.print('It is Black\'s move', 45, VIRTUAL_HEIGHT - 38)
	end
--]]

---[[TITLE
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.setFont(titleFont)
	love.graphics.print('TAK', VIRTUAL_WIDTH - 400, 40)
--]]

	--DEBUG INF0
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.setFont(smallFont)
	--love.graphics.print('stoneSelect: ' .. tostring(stoneSelect), VIRTUAL_WIDTH - 400, 180)
	if moveType == 'place' then
		love.graphics.print('moveType: place', 480, VIRTUAL_HEIGHT - 38)
	elseif moveType == 'move' then
		love.graphics.print('moveType: move', 480, VIRTUAL_HEIGHT - 38)
	end

--[[
	--INSTRUCTIONS
	love.graphics.setFont(smallerFont)
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	if movementEvent == 0 then
		love.graphics.print('Click to place your stone in an empty grid', INSTRUCTIONX, INSTRUCTIONY)
		love.graphics.print('Arrow up or down to move a stack instead', INSTRUCTIONX, INSTRUCTIONY + INSTRUCTIONYOFFSET)
	elseif movementEvent == 1 then
		love.graphics.print('Click to select a stack in your control', INSTRUCTIONX, INSTRUCTIONY)
		love.graphics.print('that you want to move', INSTRUCTIONX, INSTRUCTIONY + INSTRUCTIONYOFFSET - 25)
		--love.graphics.print('Arrow up or down to move a stack instead', INSTRUCTIONX, INSTRUCTIONY + INSTRUCTIONYOFFSET * 4)
	elseif movementEvent == 2 then
		love.graphics.print('Arrow up or down to select amount of', INSTRUCTIONX, INSTRUCTIONY)
		love.graphics.print('stones that you want to move', INSTRUCTIONX, INSTRUCTIONY + INSTRUCTIONYOFFSET - 25)
		love.graphics.print('Press enter to lock in your hand', INSTRUCTIONX, INSTRUCTIONY + INSTRUCTIONYOFFSET * 2)
	elseif movementEvent == 3 then
		love.graphics.print('Click to select a green grid that you want to move to', INSTRUCTIONX, INSTRUCTIONY)
		love.graphics.print('that you want to move to', INSTRUCTIONX, INSTRUCTIONY + INSTRUCTIONYOFFSET - 25)
	elseif movementEvent >= 4 then
		love.graphics.print('Arrow up or down to select amount of', INSTRUCTIONX, INSTRUCTIONY)
		love.graphics.print('stones that you want to place', INSTRUCTIONX, INSTRUCTIONY + INSTRUCTIONYOFFSET - 25)
		love.graphics.print('Press enter to lock in amount', INSTRUCTIONX, INSTRUCTIONY + INSTRUCTIONYOFFSET * 2)
		love.graphics.print('of stones dropped', INSTRUCTIONX, INSTRUCTIONY + INSTRUCTIONYOFFSET * 3 - 25)
	end
--]]

---[[
	if debugOption == 1 then
		love.graphics.print('GRID[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. ']', VIRTUAL_WIDTH - 490, DEBUGY)
		love.graphics.print('legalMove: ' ..tostring(grid[mouseYGrid][mouseXGrid].legalMove), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET)
		love.graphics.print('stackControl: ' ..tostring(grid[mouseYGrid][mouseXGrid].stackControl), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 2)
		love.graphics.print('stoneControl: ' ..tostring(grid[mouseYGrid][mouseXGrid].stoneControl), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 3)
		love.graphics.print('MS.occupants: ' .. tostring(mouseStones.occupants), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 4)	
		love.graphics.print('GRID.occupants: ' .. tostring(grid[mouseYGrid][mouseXGrid].occupants), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 5)
		love.graphics.print('LMS stackOrder: ' .. tostring(lowestMSStackOrder), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 6)
		love.graphics.print('LM Highlight: : ' .. tostring(grid[mouseYGrid][mouseXGrid].legalMoveHighlight), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 7)
		love.graphics.print('movementEvent#: ' .. tostring(movementEvent), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 8)
		love.graphics.print('Stone2Copy: ' .. tostring(stonesToCopy), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 9) --lowestSurroundingOccupants
		love.graphics.print('lowestSurrOcc: ' .. tostring(lowestSurroundingOccupants), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 10) --lowestSurroundingOccupants mouseStones.stoneControl
		love.graphics.print('MSStoneContrl: ' .. tostring(mouseStones.stoneControl), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 11) --lowestSurroundingOccupants mouseStones.stoneControl

	end

	if debugOption == 2 then
		love.graphics.print('mOriginRow: ' .. tostring(movementOriginRow), VIRTUAL_WIDTH - 490, DEBUGY)
		love.graphics.print('mOriginColumn: ' .. tostring(movementOriginColumn), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET)
		love.graphics.print('firstMovRow: ' .. tostring(firstMovementRow), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 2)
		love.graphics.print('firstMovCol: ' .. tostring(firstMovementColumn), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 3)
		love.graphics.print('secondMovRow: ' .. tostring(secondMovementRow), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 4)
		love.graphics.print('secondMovCol: ' .. tostring(secondMovementColumn), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 5)
		love.graphics.print('thirdMovRow: ' .. tostring(thirdMovementRow), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 6)
		love.graphics.print('thirdMovCol: ' .. tostring(thirdMovementColumn), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 7)
		love.graphics.print('fourthMovRow: ' .. tostring(fourthMovementRow), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 8)
		love.graphics.print('fourthMovCol: ' .. tostring(fourthMovementColumn), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 9)
		--love.graphics.print('upLOCK: ' .. tostring(upDirection), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 4)
		--love.graphics.print('downLOCK: ' .. tostring(downDirection), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 5)
		--love.graphics.print('leftLOCK: ' .. tostring(leftDirection), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 6)
		--love.graphics.print('rightLOCK: ' .. tostring(rightDirection), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 7)
		--love.graphics.print('dropFirstMovement: ' .. tostring(droppedInFirstMovement), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 8)
		love.graphics.print('LMSSO: ' .. tostring(lowestMSStackOrder), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 10)
	end

	if debugOption == 3 then
		love.graphics.print('nextMoveRow: ' .. tostring(nextMoveRow), VIRTUAL_WIDTH - 490, DEBUGY)
		love.graphics.print('nextMoveColumn: ' .. tostring(nextMoveColumn), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET)
		love.graphics.print('offGrid: ' .. tostring(offGrid), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 2)
		love.graphics.print('.occupied: ' .. tostring(grid[mouseYGrid][mouseXGrid].occupied), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 3)
		love.graphics.print('secondMovementRow: ' .. tostring(secondMovementRow), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 4)
		love.graphics.print('secondMovementColumn: ' .. tostring(secondMovementColumn), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 5)
		love.graphics.print('mEvent1LMPopulated: ' .. tostring(mEvent1LegalMovesPopulated), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 6)
	end
--]]
	--STONE COUNT
	love.graphics.setFont(smallFont)
	love.graphics.print('player1 stones: ' .. tostring(player1stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 100)
	love.graphics.print('player2 stones: ' .. tostring(player2stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 50)
end