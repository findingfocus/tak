
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