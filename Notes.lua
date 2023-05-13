X_Win printing for two games
X_Rematch?
X_Player starting move**other player stones
X_player1 places black stone --limit stone type changes
X_player2 places white stone --limit stone type changes
X_player1 turn placing own stone
X_Debug red space upon a win
__Debug Complex move stones
__Factor Offgrid into also illegal moves?
__Loop songs, random song index so plays forever
X_Loop chatter forever

Move
	-Lock in movementOrigin
	-Drop stones
	-stonesInHandLocked = true
	-Render legal moves from movementOrigin
	-Once Grid selected, that grid is firstMovementLocked
	-Drop stones
	-Render Legalmoves from firstMovementLocked with direction locked
	-Once selected, that grid is secondMovementLocked

	--ends on fourth movement locked

	-Upon legal move check, we need to check the next legal move spaces, if there are no legal moves once placed, then we need to place them all upon a click in that space,
		Upon pressing enter, see if there are any limitations in movemnt once locked, if so, enter will only advance the player when mouseStones.occupants are empty


RESETS
		resetLegalMoves()
		movementOriginRow = 0
		movementOriginColumn = 0
		movementOriginLocked = false
		grid[mouseYGrid][mouseXGrid].moveLockedHighlight = false
		moveLockedRow = 0
		moveLockedColumn = 0
		lowestMSStackOrder = 1
		stonesInHandLocked = false
		droppedInMovementOrigin = 0
		firstMovementGridLocked = false
		downDirection = false
		upDirection = false
		leftDirection = false
		rightDirection = false
		droppedInFirstMovement = 0
		firstMovementStonesDropped = false



MOVE REHAUL

CLICKDETECTION
	mEvent = 1 noMoveLocked --SELECT LEGAL MOVE HIGHLIGHT
		--LEGALMOVE HIGHLIGHT == TRUE UPON MOUSEOVER

	mEvent = 2 movementOriginLocked --DECIDE HOW MANY STONES IN HAND
	mEvent = 3 stonesInHandLocked --SELECT LEGALMOVE DIRECTION
	mEvent = 4 firstMovementLocked --DROP AT LEAST ONE STONE --FIRSTDARKGREEN BOX
	mEvent = 5 secondMovementLocked --DROP AT LEAST ONE STONE --SECONDDARKGREEN BOX
	mEvent = 6 thirdMovementLocked --DROP AT LEAST ONE STONE --THIRDDARKGREEN BOX
	mEvent = 7 fourthMovementLocked --DROP ALL STONES HERE, PRESS ENTER

IF UP DETECTION
	mEvent = 1 noMoveLocked --SELECT LEGAL MOVE HIGHLIGHT
		--LEGALMOVE HIGHLIGHT == TRUE UPON MOUSEOVER

	mEvent = 2 movementOriginLocked --DECIDE HOW MANY STONES IN HAND
	mEvent = 3 stonesInHandLocked --SELECT LEGALMOVE DIRECTION
	mEvent = 4 firstMovementLocked --DROP AT LEAST ONE STONE --FIRSTDARKGREEN BOX
	mEvent = 5 secondMovementLocked --DROP AT LEAST ONE STONE --SECONDDARKGREEN BOX
	mEvent = 6 thirdMovementLocked --DROP AT LEAST ONE STONE --THIRDDARKGREEN BOX
	mEvent = 7 fourthMovementLocked --DROP ALL STONES HERE, PRESS ENTER

IF DOWN DETECTION
	mEvent = 1 noMoveLocked --SELECT LEGAL MOVE HIGHLIGHT
		--LEGALMOVE HIGHLIGHT == TRUE UPON MOUSEOVER

	mEvent = 2 movementOriginLocked --DECIDE HOW MANY STONES IN HAND
	mEvent = 3 stonesInHandLocked --SELECT LEGALMOVE DIRECTION
	mEvent = 4 firstMovementLocked --DROP AT LEAST ONE STONE --FIRSTDARKGREEN BOX
	mEvent = 5 secondMovementLocked --DROP AT LEAST ONE STONE --SECONDDARKGREEN BOX
	mEvent = 6 thirdMovementLocked --DROP AT LEAST ONE STONE --THIRDDARKGREEN BOX
	mEvent = 7 fourthMovementLocked --DROP ALL STONES HERE, PRESS ENTER

IF ENTER DETECTION
	mEvent = 1 noMoveLocked --SELECT LEGAL MOVE HIGHLIGHT
		--LEGALMOVE HIGHLIGHT == TRUE UPON MOUSEOVER

	mEvent = 2 movementOriginLocked --DECIDE HOW MANY STONES IN HAND
	mEvent = 3 stonesInHandLocked --SELECT LEGALMOVE DIRECTION
	mEvent = 4 firstMovementLocked --DROP AT LEAST ONE STONE --FIRSTDARKGREEN BOX
	mEvent = 5 secondMovementLocked --DROP AT LEAST ONE STONE --SECONDDARKGREEN BOX
	mEvent = 6 thirdMovementLocked --DROP AT LEAST ONE STONE --THIRDDARKGREEN BOX
	mEvent = 7 fourthMovementLocked --DROP ALL STONES HERE, PRESS ENTER






	mEvent = 1 noMoveLocked --SELECT LEGAL MOVE HIGHLIGHT
		--SET LEGAL MOVES UPON STACKCONTROL
		--RENDER LEGALMOVEHIGHLIGHTS UPON MOUSEOVER
		if Clicked AND LEGALMOVE
			--PLACE TOP FIVE STONES IN HAND
			movementOriginRow
			movementOriginColumn
			mEvent = 2
	mEvent = 2 movementOriginLocked --DECIDE HOW MANY STONES IN HAND
		if Down
			--DROP
		if Up 
			--PICKUP
		if enter --HAVE TO HAVE DROPPED 1
			stonesInHandLocked --SELECT LEGALMOVE DIRECTION
			updateStackControl:movementOriginGrid
			updateStoneControl:movementOriginGrid
			mEvent = 3 
	mEvent = 3 firstMovementGridLocked
		LM for all orthognal
		if Clicked
			lock in FMGrid

	mEvent = 4 firstMovementLocked --DROP AT LEAST ONE STONE IN FM GRID --FIRSTDARKGREEN BOX
		--SET LEGALMOVES OTHOGANAL SPACE --AND NOT CS,SS, or end of grid
		if Down
			--DROP
		if Up
			--Pickup
		if enter
			updateStackControl:FirstMovementGrid
			updateStoneControl:FirstMovementGrid
			mEvent = 5
	mEvent = 5 secondMovementLocked --DROP AT LEAST ONE STONE --SECONDDARKGREEN BOX
		if Down
			--DROP
		if Up
			--Pickup
		if enter
			updateStackControl:SecondMovementGrid
			updateStoneControl:SecondMovementGrid
			mEvent = 6
	mEvent = 6 thirdMovementLocked --DROP AT LEAST ONE STONE --THIRDDARKGREEN BOX
		if Down
			--DROPOFF
		if Up
			--PICKUP
		if enter
			updateStackControl:ThirdMovementGrid
			updateStoneControl:ThirdMovementGrid
			mEvent = 7
	mEvent = 7 fourthMovementLocked --DROP ALL STONES HERE, PRESS ENTER
		if Down
			--DROP
		if enter and mouseOccupants == 0
			resetVariables
			swapPlayer()

